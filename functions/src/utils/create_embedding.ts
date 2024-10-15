import { OpenAI } from "openai";

/**
 *
 * @function createEmbedding
 * @param {OpenAI} openai
 * @param {string} input
 * @return {number[]}
 */
export const createEmbedding = async (
  openai: OpenAI,
  input: string
): Promise<number[]> => {
  const responce = await openai.embeddings.create({
    model: "text-embedding-3-small",
    input: input,
    encoding_format: "float",
  });
  return responce.data[0].embedding;
};
