import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { Question } from "../models/question";
import { OpenAI } from "openai";
import { createEmbedding } from "../utils/create_embedding";
import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { Embedding } from "../models/embedding";
import { logger } from "firebase-functions/v2";

export const addEmbedding = onDocumentCreated(
  {
    document: "questions/{questionId}",
    secrets: ["OPENAI_API_KEY"],
    region: "asia-northeast1",
  },
  async (event) => {
    const data = event.data?.data();
    if (!data) return;
    const question = new Question(data);

    logger.info(`Added question: ${question.questionId}`);

    const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
    const input: string =
      "Q: " +
      question.quest +
      "A1: " +
      question.answer1 +
      "A2: " +
      question.answer2;
    const embedding: number[] = await createEmbedding(openai, input);
    const db = getFirestore();
    const embeddingRef = db.collection("embeddings").doc(question.questionId);
    const embeddingData = new Embedding({
      questionId: question.questionId,
      embedding: FieldValue.vector(embedding),
    });
    const ret = await embeddingRef.set(embeddingData.toFirestore(), {
      merge: true,
    });
    return ret;
  }
);
