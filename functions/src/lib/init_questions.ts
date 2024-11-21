import { getFirestore } from "firebase-admin/firestore";
import { onCall } from "firebase-functions/v2/https";
import { getQuestionsSet } from "../utils/get_questions_set";
import { Question } from "../models/question";
import { logger } from "firebase-functions/v2";
import { cacheQuestions } from "../utils/cache_questions";

export const initQuestions = onCall(
  {
    region: "asia-northeast1",
    enforceAppCheck: true,
  },
  async (request) => {
    const authId = request.auth?.uid;
    const initQuestionId = request.data?.questionId;
    if (!authId) return [];

    logger.info(`authId: ${authId}, initQuestionId: ${initQuestionId}`);

    const db = getFirestore();
    const questionsSet = await getQuestionsSet(authId, db);

    if (initQuestionId && initQuestionId.length > 0) {
      const questionRef = db.collection("questions").doc(initQuestionId);
      const questionDoc = await questionRef.get();
      if (questionDoc.exists) {
        const data = questionDoc.data();
        if (data) {
          const question = new Question(data);
          const index = questionsSet.findIndex(
            (q) => q.questionId === question.questionId
          );
          if (index !== -1) questionsSet.splice(index, 1);
          questionsSet.unshift(question);
        }
      }
    }

    await cacheQuestions(db, authId, questionsSet.slice(0, 40));

    return questionsSet.slice(0, 40);
  }
);
