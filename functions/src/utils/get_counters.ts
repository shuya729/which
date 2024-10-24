import { Firestore } from "firebase-admin/firestore";
import { Question } from "../models/question";
import { Counter } from "../models/counter";

export const getCounters = async (
  db: Firestore,
  questions: Question[]
): Promise<Counter[]> => {
  const counters: Counter[] = [];
  const counterCollectionGroup = db.collectionGroup("shards");

  if (questions.length === 0) return counters;
  const questionIds: string[] = questions.map(
    (question) => question.questionId
  );

  for (let i = 0; i < questionIds.length / 30; i++) {
    const questionIdsSlice = questionIds.slice(i * 30, (i + 1) * 30);
    const counterQuery = counterCollectionGroup.where(
      "questionId",
      "in",
      questionIdsSlice
    );
    const counterSnapshots = await counterQuery.get();
    if (counterSnapshots.empty) continue;

    for (const questionId of questionIdsSlice) {
      const docs = counterSnapshots.docs.find(
        (doc) => doc.data().questionId === questionId
      );
      if (docs) counters.push(Counter.fromDocs([docs]));
    }
  }

  return counters;
};
