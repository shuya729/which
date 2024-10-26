import { initializeApp } from "firebase-admin/app";
import { getQuestions } from "./lib/get_questions";
import { initQuestions } from "./lib/init_questions";
import { searchQuestions } from "./lib/search_questions";
import { addEmbedding } from "./lib/add_embedding";
import { deleteQuestion } from "./lib/delete_question";
import { deleteUser } from "./lib/delete_user";
import { userCrawler } from "./lib/user_crawler";

initializeApp();

const timezone = "Asia/Tokyo";
process.env.TZ = timezone;

export { getQuestions };
export { initQuestions };
export { searchQuestions };
export { addEmbedding };
export { deleteQuestion };
export { deleteUser };
export { userCrawler };
