import { getFirestore } from "firebase-admin/firestore";
import { onCall } from "firebase-functions/v2/https";
import { getQuestionsSet } from "../utils/get_questions_set";
import { logger } from "firebase-functions/v2";
import { cacheQuestions } from "../utils/cache_questions";

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

    await cacheQuestions(db, authId, questionsSet.slice(0, 20));

    return questionsSet.slice(0, 20);
  }
);
