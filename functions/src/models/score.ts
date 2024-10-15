/**
 * Score クラスは、質問に関連するスコアを保持します。
 */
export class Score {
  /** 質問ID */
  questionId: string;

  /** 埋め込みスコア */
  embeddingScore: number;

  /** 最新スコア */
  latestScore: number;

  /** 人気スコア */
  popularScore: number;

  /**
   * コンストラクタは、質問IDを受け取り、スコアを初期化します。
   * @param {string} questionId - 質問ID
   */
  constructor(questionId: string) {
    this.questionId = questionId;
    this.embeddingScore = 0.0;
    this.latestScore = 0.0;
    this.popularScore = 0.0;
  }

  /**
   * 埋め込みスコアを設定します。
   * @param {number} score - 設定するスコア
   */
  setEmbeddingScore(score: number) {
    this.embeddingScore = score;
  }

  /**
   * 最新スコアを設定します。
   * @param {number} score - 設定するスコア
   */
  setLatestScore(score: number) {
    this.latestScore = score;
  }

  /**
   * 人気スコアを設定します。
   * @param {number} score - 設定するスコア
   */
  setPopularScore(score: number) {
    this.popularScore = score;
  }

  /**
   * 合計スコアを取得します。
   * @return {number} 合計スコア
   */
  get totalScore(): number {
    return this.embeddingScore + this.latestScore + this.popularScore;
  }
}
