/**
 * スコアを計算する関数。
 *
 * @function calcScore
 * @param {number} index - 現在のインデックス
 * @param {number} length - 全体の長さ
 * @param {number} rate - レート
 * @return {number} 計算されたスコア
 */
export function calcScore(index: number, length: number, rate: number): number {
  if (length === 0) return 0;
  return ((length - index) / (((1 + length) * length) / 2)) * rate;
}
