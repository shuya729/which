import { Counter } from "../models/counter";
import { Embedding } from "../models/embedding";
import { Question } from "../models/question";
import { Score } from "../models/score";
import { calcScore } from "./calc_score";

export const sortQuestions = (
  embedding: number[],
  embeddings: Embedding[],
  counters: Counter[],
  questions: Question[],
  embeddingRate: number,
  latestRate: number,
  popularRate: number
): Question[] => {
  // スコアを記録するMap
  const scoreMap: Map<string, Score> = new Map();
  questions.forEach((question) =>
    scoreMap.set(question.questionId, new Score(question.questionId))
  );

  // embeddingsがembeddingとのコサイン類似度が高い順にソート
  const embeddingOrderIds: string[] = [];
  embeddings.sort((a, b) => {
    const dotA =
      a.embedding.reduce((acc, cur, i) => {
        if (cur === 0) return acc;
        return acc + cur * embedding[i];
      }, 0) /
      Math.sqrt(
        a.embedding.reduce((acc, cur) => {
          if (cur === 0) return acc;
          return acc + cur * cur;
        }, 0)
      );
    const dotB =
      b.embedding.reduce((acc, cur, i) => {
        if (cur === 0) return acc;
        return acc + cur * embedding[i];
      }, 0) /
      Math.sqrt(
        b.embedding.reduce((acc, cur) => {
          if (cur === 0) return acc;
          return acc + cur * cur;
        }, 0)
      );
    return dotB - dotA;
  });
  embeddings.forEach((embedding) =>
    embeddingOrderIds.push(embedding.questionId)
  );

  // questionsのcreAtが新しい順にソート
  const latestOrderIds: string[] = [];
  questions.sort((a, b) => b.creAt.seconds - a.creAt.seconds);
  questions.forEach((question) => latestOrderIds.push(question.questionId));

  // questionsのpopularRateが高い順にソート
  const popularOrderIds: string[] = [];
  questions.sort((a, b) => {
    const indexA = counters.findIndex(
      (counter) => counter.questionId === a.questionId
    );
    const indexB = counters.findIndex(
      (counter) => counter.questionId === b.questionId
    );
    if (indexA === -1) return 1;
    if (indexB === -1) return -1;
    const popularA = counters[indexA].getPopular();
    const popularB = counters[indexB].getPopular();
    return popularB - popularA;
  });
  questions.forEach((question) => popularOrderIds.push(question.questionId));

  // スコアリング
  if (questions.length > 0) {
    questions.forEach((question) => {
      const score = scoreMap.get(question.questionId);
      if (!score) return;
      const embeddingIndex = embeddingOrderIds.indexOf(question.questionId);
      score.setEmbeddingScore(
        calcScore(embeddingIndex, questions.length, embeddingRate)
      );
      const latestIndex = latestOrderIds.indexOf(question.questionId);
      score.setLatestScore(
        calcScore(latestIndex, questions.length, latestRate)
      );
      const popularIndex = popularOrderIds.indexOf(question.questionId);
      score.setPopularScore(
        calcScore(popularIndex, questions.length, popularRate)
      );
      scoreMap.set(question.questionId, score);
    });
  }

  // questionsをスコアが高い順にソート
  questions.sort((a, b) => {
    const scoreA = scoreMap.get(a.questionId);
    const scoreB = scoreMap.get(b.questionId);
    if (!scoreA) return 1;
    if (!scoreB) return -1;
    return scoreB.totalScore - scoreA.totalScore;
  });

  return questions;
};
