import { region } from "firebase-functions/v1";
import { getFirestore } from "firebase-admin/firestore";
import { UserInfo } from "../models/user_info";
import { logger } from "firebase-functions/v2";

export const createUser = region("asia-northeast1")
  .auth.user()
  .onCreate(async (user) => {
    const authId = user.uid;
    const db = getFirestore();

    logger.info(`Created user: ${authId}`);

    const infoRef = db.collection("infos").doc(authId);
    await infoRef.set(UserInfo.forCreate(user), { merge: true });
  });
