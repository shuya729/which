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
    this.questionId = data.questionId ?? "";
    this.authId = data.authId ?? "";
    this.quest = data.quest ?? "";
    this.answer1 = data.answer1 ?? "";
    this.answer2 = data.answer2 ?? "";
    this.editedFlg = data.editedFlg ?? false;
    this.hiddenFlg = data.hiddenFlg ?? false;
    this.deletedFlg = data.deletedFlg ?? false;
    this.rejectedFlg = data.rejectedFlg ?? false;
    this.creAt = data.creAt ?? Timestamp.now();
    this.updAt = data.updAt ?? Timestamp.now();
  }
}
