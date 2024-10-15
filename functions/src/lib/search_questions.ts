import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { onCall } from "firebase-functions/v2/https";
import { OpenAI } from "openai";
import { createEmbedding } from "../utils/create_embedding";
import { Question } from "../models/question";
import { Embedding } from "../models/embedding";

export const searchQuestions = onCall(
  {
    secrets: ["OPENAI_API_KEY"],
    region: "asia-northeast1",
  },
  async (request) => {
    const authId = request.auth?.uid;
    const input: string = request.data?.input;
    if (!authId || !input || input.length === 0) return [];

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
      limit: 30,
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
      const questionsQuery = questionsCollection
        .where("questionId", "in", embeddingIds.slice(0, 30))
        .limit(30);
      const questionsSnapshots = await questionsQuery.get();
      questionsSnapshots.forEach((doc) => {
        if (doc.exists) questions.push(new Question(doc.data()));
      });
    }

    // embeddingsがembeddingとのコサイン類似度が高い順にソート
    const embeddingOrderIds: string[] = [];
    embeddings.sort((a, b) => {
      const dotA =
        a.embedding.reduce((acc, cur, i) => {
          if (cur === 0) return acc;
          return acc + cur * embedding[i];
        }, 0) /
        Math.sqrt(
          a.embedding.reduce((acc, cur) => {
            if (cur === 0) return acc;
            return acc + cur * cur;
          }, 0)
        );
      const dotB =
        b.embedding.reduce((acc, cur, i) => {
          if (cur === 0) return acc;
          return acc + cur * embedding[i];
        }, 0) /
        Math.sqrt(
          b.embedding.reduce((acc, cur) => {
            if (cur === 0) return acc;
            return acc + cur * cur;
          }, 0)
        );
      return dotB - dotA;
    });
    embeddings.forEach((embedding) =>
      embeddingOrderIds.push(embedding.questionId)
    );

    // questionsがembeddingOrderIdsの順に並び替え
    questions.sort((a, b) => {
      const aIndex = embeddingOrderIds.indexOf(a.questionId);
      const bIndex = embeddingOrderIds.indexOf(b.questionId);
      return aIndex - bIndex;
    });

    return questions;
  }
);
