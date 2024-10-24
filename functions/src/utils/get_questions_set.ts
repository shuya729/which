import { FieldValue, Firestore } from "firebase-admin/firestore";

import { Question } from "../models/question";
import { Embedding } from "../models/embedding";
import { calcScore } from "../utils/calc_score";
import { sortQuestions } from "./sort_questions";
import { Counter } from "../models/counter";
import { getCounters } from "./get_counters";

/**
 * スコアを計算する関数。
 *
 * @function
 * @param {string} authId - 認証ID
 * @param {Firestore} db - Firestore
 * @return {Question[]}
 */
export const getQuestionsSet = async (
  authId: string,
  db: Firestore
): Promise<Question[]> => {
  const questions: Question[] = [];
  const embeddings: Embedding[] = [];

  const userRef = db.collection("users").doc(authId);
  const questionsCollection = db.collection("questions");
  const embeddingsCollection = db.collection("embeddings");
  const readedCollection = userRef.collection("readed");
  const watchedCollection = userRef.collection("watched");

  const readedIds: string[] = []; // max 60
  const readedQuery = readedCollection.orderBy("creAt", "desc").limit(60);
  const readedSnapshots = await readedQuery.get();
  readedSnapshots.forEach((doc) => {
    if (doc.exists && doc.id) readedIds.push(doc.id);
  });

  const watchedIds: string[] = []; // max 60
  const watchedQuery = watchedCollection.orderBy("creAt", "desc").limit(60);
  const watchedSnapshots = await watchedQuery.get();
  watchedSnapshots.forEach((doc) => {
    if (doc.exists && doc.id && readedIds.includes(doc.id)) {
      watchedIds.push(doc.id);
    }
  });

  let embeddingRate = 0.0;
  watchedIds.forEach(() => (embeddingRate += 0.012));
  const latestRate: number = (1 - embeddingRate) * 0.5;
  const popularRate: number = (1 - embeddingRate) * 0.5;

  const embedding: number[] = Array(1536).fill(0);
  const embeddingIds: string[] = []; // max90(60件まで被る可能性あり)
  if (0 < watchedIds.length) {
    const watchedEmbeddings: Embedding[] = [];
    const watchedEmbeddingQuery1 = embeddingsCollection
      .where("questionId", "in", watchedIds.slice(0, 30))
      .limit(30);
    const watchedEmbeddingSnapshots1 = await watchedEmbeddingQuery1.get();
    watchedEmbeddingSnapshots1.forEach((doc) => {
      if (doc.exists) watchedEmbeddings.push(new Embedding(doc.data()));
    });
    if (30 < watchedIds.length && watchedIds.length <= 60) {
      const watchedEmbeddingQuery2 = embeddingsCollection
        .where("questionId", "in", watchedIds.slice(30))
        .limit(30);
      const watchedEmbeddingSnapshots2 = await watchedEmbeddingQuery2.get();
      watchedEmbeddingSnapshots2.forEach((doc) => {
        if (doc.exists) watchedEmbeddings.push(new Embedding(doc.data()));
      });
    }
    watchedEmbeddings.sort((a, b) => {
      const aIndex = watchedIds.indexOf(a.questionId);
      const bIndex = watchedIds.indexOf(b.questionId);
      if (aIndex === -1) return 1;
      if (bIndex === -1) return -1;
      return aIndex - bIndex;
    });
    watchedEmbeddings.forEach((watchedEmbedding, index) => {
      watchedEmbedding.embedding.forEach((value, i) => {
        if (value === 0 || watchedEmbeddings.length === 0) return;
        embedding[i] += value * calcScore(index, watchedEmbeddings.length, 1.0);
      });
    });

    const embeddingQuery = embeddingsCollection.findNearest({
      vectorField: "embedding",
      queryVector: FieldValue.vector(embedding),
      limit: 90,
      distanceMeasure: "DOT_PRODUCT",
    });
    const embeddingSnapshots = await embeddingQuery.get();
    embeddingSnapshots.forEach((doc) => {
      if (doc.exists && doc.id && !readedIds.includes(doc.id)) {
        embeddingIds.push(doc.id);
        embeddings.push(new Embedding(doc.data()));
      }
    });
  }

  if (embeddingIds.length > 0) {
    const embeddingQuestionQuery1 = questionsCollection
      .where("questionId", "in", embeddingIds.slice(0, 30))
      .limit(30);
    const embeddingQuestionSnapshots1 = await embeddingQuestionQuery1.get();
    embeddingQuestionSnapshots1.forEach((doc) => {
      if (doc.exists && !readedIds.includes(doc.id)) {
        questions.push(new Question(doc.data()));
      }
    });
    if (30 < embeddingIds.length) {
      const embeddingQuestionQuery2 = questionsCollection
        .where("questionId", "in", embeddingIds.slice(30, 60))
        .limit(30);
      const embeddingQuestionSnapshots2 = await embeddingQuestionQuery2.get();
      embeddingQuestionSnapshots2.forEach((doc) => {
        if (doc.exists && !readedIds.includes(doc.id)) {
          questions.push(new Question(doc.data()));
        }
      });
    }
    if (60 < embeddingIds.length && embeddingIds.length <= 90) {
      const embeddingQuestionQuery3 = questionsCollection
        .where("questionId", "in", embeddingIds.slice(60))
        .limit(30);
      const embeddingQuestionSnapshots3 = await embeddingQuestionQuery3.get();
      embeddingQuestionSnapshots3.forEach((doc) => {
        if (doc.exists && !readedIds.includes(doc.id)) {
          questions.push(new Question(doc.data()));
        }
      });
    }
  }

  const latestIds: string[] = []; // max90(60件まで被る)
  const latestQuestionQuery = questionsCollection
    .orderBy("creAt", "desc")
    .limit(90);
  const latestQuestionSnapshots = await latestQuestionQuery.get();
  latestQuestionSnapshots.forEach((doc) => {
    if (
      doc.exists &&
      !readedIds.includes(doc.id) &&
      !embeddingIds.includes(doc.id)
    ) {
      latestIds.push(doc.id);
      questions.push(new Question(doc.data()));
    }
  });

  if (0 < latestIds.length) {
    const latestEmbeddingQuery1 = embeddingsCollection
      .where("questionId", "in", latestIds.slice(0, 30))
      .limit(30);
    const latestEmbeddingSnapshots1 = await latestEmbeddingQuery1.get();
    latestEmbeddingSnapshots1.forEach((doc) => {
      if (doc.exists) embeddings.push(new Embedding(doc.data()));
    });
    if (30 < latestIds.length) {
      const latestEmbeddingQuery2 = embeddingsCollection
        .where("questionId", "in", latestIds.slice(30, 60))
        .limit(30);
      const latestEmbeddingSnapshots2 = await latestEmbeddingQuery2.get();
      latestEmbeddingSnapshots2.forEach((doc) => {
        if (doc.exists) embeddings.push(new Embedding(doc.data()));
      });
    }
    if (60 < latestIds.length && latestIds.length <= 90) {
      const latestEmbeddingQuery3 = embeddingsCollection
        .where("questionId", "in", latestIds.slice(60))
        .limit(30);
      const latestEmbeddingSnapshots3 = await latestEmbeddingQuery3.get();
      latestEmbeddingSnapshots3.forEach((doc) => {
        if (doc.exists) embeddings.push(new Embedding(doc.data()));
      });
    }
  }

  const counters: Counter[] = await getCounters(db, questions);

  const sortedQuestions: Question[] = sortQuestions(
    embedding,
    embeddings,
    counters,
    questions,
    embeddingRate,
    latestRate,
    popularRate
  );

  return sortedQuestions;
};
