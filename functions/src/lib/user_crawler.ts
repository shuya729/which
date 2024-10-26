import { Firestore, getFirestore, Query } from "firebase-admin/firestore";
import { Storage, getStorage } from "firebase-admin/storage";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { UserInfo } from "../models/user_info";
import { deleteUserFunc } from "./delete_user";
import { Auth, getAuth } from "firebase-admin/auth";

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
    const storage = getStorage();
    const auth = getAuth();

    const query = db
      .collection("infos")
      .where("anonymousFlg", "==", true)
      .where("lastAt", "<", now.getTime() - baseTime);

    await deleteUsersFunc(db, storage, auth, query);
  }
);

const deleteUsersFunc = async (
  db: Firestore,
  storage: Storage,
  auth: Auth,
  ref: Query
): Promise<void> => {
  const query = ref.limit(1000);
  const snapshot = await query.get();
  if (snapshot.empty) return;

  const authIds: string[] = [];
  snapshot.docs.forEach((doc) => {
    authIds.push(new UserInfo(doc.data()).authId);
  });

  for (const authId of authIds) {
    await deleteUserFunc(authId, db, storage);
  }

  await auth.deleteUsers(authIds);

  await deleteUsersFunc(db, storage, auth, ref);
};
