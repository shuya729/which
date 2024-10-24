/**
 * Counterクラスは質問に対する統計情報を保持します。
 */
export class Counter {
  questionId: string;
  readed: number;
  watched: number;
  answer1: number;
  answer2: number;

  /**
   * Counterのコンストラクタ
   * @param {string} questionId - 質問のID
   * @param {number} readed - 読まれた回数
   * @param {number} watched - 見られた回数
   * @param {number} answer1 - 回答1の数
   * @param {number} answer2 - 回答2の数
   */
  constructor(
    questionId: string,
    readed: number,
    watched: number,
    answer1: number,
    answer2: number
  ) {
    this.questionId = questionId ?? "";
    this.readed = readed ?? 0;
    this.watched = watched ?? 0;
    this.answer1 = answer1 ?? 0;
    this.answer2 = answer2 ?? 0;
  }

  /**
   * ドキュメントの配列からCounterインスタンスを生成します。
   * @param {Array<FirebaseFirestore.QueryDocumentSnapshot>} docs - ドキュメントの配列
   * @return {Counter} Counterインスタンス
   */
  static fromDocs(
    docs: Array<FirebaseFirestore.QueryDocumentSnapshot>
  ): Counter {
    const questionId = docs[0].data().questionId;
    let readed = 0;
    let watched = 0;
    let answer1 = 0;
    let answer2 = 0;

    docs.forEach((doc) => {
      const data = doc.data();
      if (data.questionId === questionId) {
        readed += data.readed;
        watched += data.watched;
        answer1 += data.answer1;
        answer2 += data.answer2;
      }
    });

    return new Counter(questionId, readed, watched, answer1, answer2);
  }

  /**
   * 人気度を取得します。
   * @return {number} 人気度
   */
  getPopular(): number {
    const watched = this.watched;
    const readed = this.readed;
    if (watched >= readed) return 1;
    return watched / readed;
  }
}
