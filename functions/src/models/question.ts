import { Timestamp } from "firebase-admin/firestore";

/**
 * Question クラスは、質問に関する情報を保持します。
 */
export class Question {
  /** 質問ID */
  readonly questionId: string;

  /** 認証ID */
  readonly authId: string;

  /** 質問内容 */
  readonly quest: string;

  /** 回答1 */
  readonly answer1: string;

  /** 回答2 */
  readonly answer2: string;

  /** 読まれた回数 */
  readonly readCount: number;

  /** 回答1の回数 */
  readonly answer1Count: number;

  /** 回答2の回数 */
  readonly answer2Count: number;

  /** 編集フラグ */
  readonly editedFlg: boolean;

  /** 非表示フラグ */
  readonly hiddenFlg: boolean;

  /** 削除フラグ */
  readonly deletedFlg: boolean;

  /** 拒否フラグ */
  readonly rejectedFlg: boolean;

  /** 作成日時 */
  readonly creAt: Timestamp;

  /** 更新日時 */
  readonly updAt: Timestamp;

  /**
   * コンストラクタは、FirebaseFirestore.DocumentData からデータを初期化します。
   * @param {FirebaseFirestore.DocumentData} data - 初期化に使用するデータ
   */
  constructor(data: FirebaseFirestore.DocumentData) {
    this.questionId = data.questionId;
    this.authId = data.authId;
    this.quest = data.quest;
    this.answer1 = data.answer1;
    this.answer2 = data.answer2;
    this.readCount = data.readCount;
    this.answer1Count = data.answer1Count;
    this.answer2Count = data.answer2Count;
    this.editedFlg = data.editedFlg;
    this.hiddenFlg = data.hiddenFlg;
    this.deletedFlg = data.deletedFlg;
    this.rejectedFlg = data.rejectedFlg;
    this.creAt = data.creAt;
    this.updAt = data.updAt;
  }

  /**
   * 人気度を計算します。
   * @return {number} 人気度
   */
  get getPopularRate(): number {
    return (this.answer1Count + this.answer2Count) / this.readCount;
  }
}
