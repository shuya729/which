import { initializeApp } from "firebase-admin/app";
import { getQuestions } from "./lib/get_questions";
import { initQuestions } from "./lib/init_questions";
import { searchQuestions } from "./lib/search_questions";
import { addEmbedding } from "./lib/add_embedding";
import { deleteEmbedding } from "./lib/delete_embedding";

initializeApp();

export { getQuestions };
export { initQuestions };
export { searchQuestions };
export { addEmbedding };
export { deleteEmbedding };
