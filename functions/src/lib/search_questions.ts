import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { onCall } from "firebase-functions/v2/https";
import { OpenAI } from "openai";
import { createEmbedding } from "../utils/create_embedding";
import { Question } from "../models/question";
import { Embedding } from "../models/embedding";
import { sortQuestions } from "../utils/sort_questions";
import { getCounters } from "../utils/get_counters";
import { Counter } from "../models/counter";

export const searchQuestions = onCall(
  {
    secrets: ["OPENAI_API_KEY"],
    region: "asia-northeast1",
  },
  async (request) => {
    const authId = request.auth?.uid;
    const input: string = request.data?.input;
    if (!authId || !input || input.length === 0) return [];

    const embeddingRate = 0.72;
    const latestRate = 0.14;
    const popularRate = 0.14;

    const questions: Question[] = [];
    const embeddings: Embedding[] = [];

    const db = getFirestore();
    const questionsCollection = db.collection("questions");
    const embeddingsCollection = db.collection("embeddings");

    const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
    const embedding: number[] = await createEmbedding(openai, input);

    const embeddingIds: string[] = [];
    const embeddingsQuery = embeddingsCollection.findNearest({
      vectorField: "embedding",
      queryVector: FieldValue.vector(embedding),
      limit: 60,
      distanceMeasure: "DOT_PRODUCT",
    });
    const embeddingsSnapshots = await embeddingsQuery.get();
    embeddingsSnapshots.forEach((doc) => {
      if (doc.exists && doc.id) {
        embeddingIds.push(doc.id);
        embeddings.push(new Embedding(doc.data()));
      }
    });

    if (embeddingIds.length > 0) {
      const questionsQuery1 = questionsCollection
        .where("questionId", "in", embeddingIds.slice(0, 30))
        .limit(30);
      const questionsSnapshots1 = await questionsQuery1.get();
      questionsSnapshots1.forEach((doc) => {
        if (doc.exists) questions.push(new Question(doc.data()));
      });
      if (30 < embeddingIds.length && embeddingIds.length <= 60) {
        const questionsQuery2 = questionsCollection
          .where("questionId", "in", embeddingIds.slice(30))
          .limit(30);
        const questionsSnapshots2 = await questionsQuery2.get();
        questionsSnapshots2.forEach((doc) => {
          if (doc.exists) questions.push(new Question(doc.data()));
        });
      }
    }

    const counters: Counter[] = await getCounters(db, questions);

    const sortedQuestions: Question[] = sortQuestions(
      embedding,
      embeddings,
      counters,
      questions,
      embeddingRate,
      latestRate,
      popularRate
    );

    return sortedQuestions.slice(0, 40);
  }
);
