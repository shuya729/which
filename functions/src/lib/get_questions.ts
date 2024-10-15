import { getFirestore } from "firebase-admin/firestore";
import { onCall } from "firebase-functions/v2/https";
import { getQuestionsSet } from "../utils/get_questions_set";

export const getQuestions = onCall(
  {
    region: "asia-northeast1",
  },
  async (request) => {
    const authId = request.auth?.uid;
    if (!authId) return [];

    const db = getFirestore();
    const questionsSet = await getQuestionsSet(authId, db);

    return questionsSet.slice(0, 20);
  }
);
