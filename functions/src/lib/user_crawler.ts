import { getFirestore } from "firebase-admin/firestore";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { UserInfo } from "../models/user_info";
import { getAuth } from "firebase-admin/auth";

export const userCrawler = onSchedule(
  {
    schedule: "every day 03:00",
    timeZone: "Asia/Tokyo",
    region: "asia-northeast1",
  },
  async () => {
    const now = new Date();
    const baseTime = 24 * 60 * 60 * 1000;
    const db = getFirestore();
    const auth = getAuth();

    const query = db
      .collection("infos")
      .where("anonymousFlg", "==", true)
      .where("lastAt", "<", now.getTime() - baseTime);
    const snapshot = await query.get();
    if (snapshot.empty) return;

    const authIds: string[] = [];
    snapshot.docs.forEach((doc) => {
      authIds.push(new UserInfo(doc.data()).authId);
    });

    for (const authId of authIds) {
      await auth.deleteUser(authId);
    }
  }
);
