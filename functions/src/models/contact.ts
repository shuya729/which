import { Timestamp } from "firebase-admin/firestore";

/**
 * Contactクラスは、お問い合わせ情報を表すクラスです。
 */
export class Contact {
  readonly contactId: string;
  readonly authId: string;
  readonly name: string;
  readonly email: string;
  readonly subject: number;
  readonly content: string;
  readonly creAt: Timestamp;

  /**
   * Contactクラスのコンストラクタ
   * @param {FirebaseFirestore.DocumentData} data - Firebase Firestoreからのドキュメントデータ
   */
  constructor(data: FirebaseFirestore.DocumentData) {
    this.contactId = data.contactId ?? "";
    this.authId = data.authId ?? "";
    this.name = data.name ?? "";
    this.email = data.email ?? "";
    this.subject = data.subject ?? 0;
    this.content = data.content ?? "";
    this.creAt = data.creAt ?? Timestamp.now();
  }

  /**
   * 件名を取得します。
   * @return {string} 件名
   */
  getSubject(): string {
    if (this.subject === 0) {
      return "ご意見";
    } else if (this.subject === 1) {
      return "不具合報告";
    } else if (this.subject === 2) {
      return "アカウント削除申請";
    } else if (this.subject === 3) {
      return "その他";
    } else {
      return "";
    }
  }
}
