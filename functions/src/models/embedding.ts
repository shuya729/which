import { VectorValue } from "@google-cloud/firestore";
import { FieldValue } from "firebase-admin/firestore";

/**
 * Embedding クラスは、質問IDと埋め込みベクトルを保持します。
 */
export class Embedding {
  /** 質問ID */
  readonly questionId: string;

  /** 埋め込みベクトル */
  readonly embedding: number[];

  /**
   * コンストラクタは、FirebaseFirestore.DocumentData からデータを初期化します。
   * @param {FirebaseFirestore.DocumentData} data - 初期化に使用するデータ
   */
  constructor(data: FirebaseFirestore.DocumentData) {
    this.questionId = data.questionId;
    this.embedding = (data.embedding as VectorValue).toArray();
  }

  /* toFirestore */
  /**
   * toFirestore メソッドは、Firestore に保存するデータを返します。
   * @return {FirebaseFirestore.DocumentData} Firestore に保存するデータ
   */
  toFirestore(): FirebaseFirestore.DocumentData {
    return {
      questionId: this.questionId,
      embedding: FieldValue.vector(this.embedding),
    };
  }
}
