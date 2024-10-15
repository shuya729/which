import { onDocumentDeleted } from "firebase-functions/v2/firestore";
import { Question } from "../models/question";
import { getFirestore } from "firebase-admin/firestore";

export const deleteEmbedding = onDocumentDeleted(
  {
    document: "questions/{questionId}",
    region: "asia-northeast1",
  },
  async (event) => {
    const data = event.data?.data();
    if (!data) return;
    const question = new Question(data);
    const db = getFirestore();
    const embeddingRef = db.collection("embeddings").doc(question.questionId);
    const ret = await embeddingRef.delete();
    return ret;
  }
);
