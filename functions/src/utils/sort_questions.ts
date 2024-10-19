import { logger } from "firebase-functions/v2";
import { Embedding } from "../models/embedding";
import { Question } from "../models/question";
import { Score } from "../models/score";
import { calcScore } from "./calc_score";

export const sortQuestions = (
  embedding: number[],
  embeddings: Embedding[],
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
  questions.sort((a, b) => b.getPopularRate - a.getPopularRate);
  questions.forEach((question) => popularOrderIds.push(question.questionId));

  // スコアリング
  if (questions.length > 0) {
    questions.forEach((question) => {
      const score = scoreMap.get(question.questionId);
      if (!score) return;
      const embeddingIndex = embeddingOrderIds.indexOf(question.questionId);
      if (embeddingIndex && embeddingIndex >= 0 && embeddingRate > 0) {
        score.setEmbeddingScore(
          calcScore(embeddingIndex, questions.length, embeddingRate)
        );
      }
      const latestIndex = latestOrderIds.indexOf(question.questionId);
      if (latestIndex && latestIndex >= 0 && latestRate > 0) {
        score.setLatestScore(
          calcScore(latestIndex, questions.length, latestRate)
        );
      }
      const popularIndex = popularOrderIds.indexOf(question.questionId);
      if (popularIndex && popularIndex >= 0 && popularRate > 0) {
        score.setPopularScore(
          calcScore(popularIndex, questions.length, popularRate)
        );
      }
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

  logger.info("scoreMap", scoreMap);

  return questions;
};
