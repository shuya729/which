import { Timestamp } from "firebase-admin/firestore";

/**
 * 質問IDを表すクラス
 */
export class QuestionId {
  readonly authId: string;
  readonly questionId: string;
  readonly creAt: Timestamp;

  /**
   * QuestionIdのインスタンスを作成します。
   * @param {string} authId - 認証ID
   * @param {string} questionId - 質問ID
   * @param {Timestamp} creAt - 作成日時
   */
  constructor(authId: string, questionId: string, creAt: Timestamp) {
    this.authId = authId;
    this.questionId = questionId;
    this.creAt = creAt;
  }

  /**
   * FirebaseFirestoreに保存するためのデータを作成します。
   * @param {string} authId - 認証ID
   * @param {string} questionId - 質問ID
   * @return {FirebaseFirestore.DocumentData} - 保存するデータ
   */
  static forSet(
    authId: string,
    questionId: string
  ): FirebaseFirestore.DocumentData {
    return {
      authId: authId,
      questionId: questionId,
      creAt: Timestamp.now(),
    };
  }
}
