import { UserRecord } from "firebase-admin/auth";
import { FieldValue, Timestamp } from "firebase-admin/firestore";

/**
 * Question クラスは、質問に関する情報を保持します。
 */
export class UserInfo {
  /** 認証ID */
  readonly authId: string;

  /** ユーザーID */
  readonly userId: string;

  /** 最終日付 */
  readonly lastAt: Timestamp;

  /** 匿名フラグ */
  readonly anonymousFlg: boolean;

  /**
   * コンストラクタは、FirebaseFirestore.DocumentData からデータを初期化します。
   * @param {FirebaseFirestore.DocumentData} data - 初期化に使用するデータ
   */
  constructor(data: FirebaseFirestore.DocumentData) {
    this.authId = data.authId ?? "";
    this.userId = data.userId ?? "";
    this.lastAt = data.lastAt ?? Timestamp.now();
    this.anonymousFlg = data.anonymousFlg ?? false;
  }

  /**
   * forCreate メソッドは、ユーザー情報を作成するためのデータを返します。
   * @param {UserRecord} user - ユーザー情報
   * @return {FirebaseFirestore.DocumentData} ユーザー情報を作成するためのデータ
   */
  static forCreate(user: UserRecord): FirebaseFirestore.DocumentData {
    return {
      authId: user.uid,
      userId: user.uid,
      lastAt: FieldValue.serverTimestamp(),
      anonymousFlg: true,
    };
  }
}
