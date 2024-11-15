import { getFirestore } from "firebase-admin/firestore";
import { onCall } from "firebase-functions/v2/https";
import { getQuestionsSet } from "../utils/get_questions_set";
import { logger } from "firebase-functions/v2";

export const getQuestions = onCall(
  {
    region: "asia-northeast1",
    enforceAppCheck: true,
  },
  async (request) => {
    const authId = request.auth?.uid;
    if (!authId) return [];

    logger.info(`authId: ${authId}`);

    const db = getFirestore();
    const questionsSet = await getQuestionsSet(authId, db);

    return questionsSet.slice(0, 20);
  }
);
