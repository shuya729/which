import { onDocumentDeleted } from "firebase-functions/v2/firestore";
import { deleteCollection } from "../utils/delete_collections";
import { logger } from "firebase-functions/v2";

export const deleteQuestion = onDocumentDeleted(
  {
    document: "questions/{questionId}",
    region: "asia-northeast1",
  },
  async (event) => {
    const batchSize = 100;
    const data = event.data;
    if (!data) return;

    const ref = data.ref;
    const db = ref.firestore;

    logger.info(`Deleted question: ${ref.id}`);

    const embeddingRef = db.collection("embeddings").doc(ref.id);
    await embeddingRef.delete();

    const subCollections = await ref.listCollections();
    for (const subCollection of subCollections) {
      await deleteCollection(db, subCollection, batchSize);
    }
  }
);
