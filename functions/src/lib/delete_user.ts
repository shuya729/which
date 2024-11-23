import { deleteCollection } from "../utils/delete_collections";
import { region } from "firebase-functions/v1";
import { getFirestore } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import { logger } from "firebase-functions/v2";

export const deleteUser = region("asia-northeast1")
  .auth.user()
  .onDelete(async (user) => {
    const authId = user.uid;
    const db = getFirestore();
    const storage = getStorage();

    logger.info(`Deleted user: ${authId}`);

    const infoRef = db.collection("infos").doc(authId);
    await infoRef.delete();

    const userRef = db.collection("users").doc(authId);
    await userRef.delete();

    const bucket = storage.bucket();
    const userBucket = bucket.file(`users/${authId}/icon.jpg`);
    const [bucketExists] = await userBucket.exists();
    if (bucketExists) await userBucket.delete();

    const batchSize = 100;
    const subCollections = await userRef.listCollections();
    for (const subCollection of subCollections) {
      await deleteCollection(db, subCollection, batchSize);
    }
  });
