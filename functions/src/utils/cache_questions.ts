import { Question } from "../models/question";
import { QuestionId } from "../models/question_id";

export const cacheQuestions = async (
  db: FirebaseFirestore.Firestore,
  authId: string,
  questions: Question[]
): Promise<void> => {
  if (!authId || !questions || questions.length === 0) return;

  const readedCollection = db
    .collection("users")
    .doc(authId)
    .collection("readed");

  const batch = db.batch();
  questions.forEach((question) => {
    batch.set(
      readedCollection.doc(question.questionId),
      QuestionId.forSet(authId, question.questionId),
      { merge: true }
    );
  });
  await batch.commit();
};
