import { deleteCollection } from "../utils/delete_collections";
import { user } from "firebase-functions/v1/auth";
import { getFirestore } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";

export const deleteUser = user().onDelete(async (user) => {
  const authId = user.uid;
  const db = getFirestore();
  const storage = getStorage();

  const userRef = db.collection("users").doc(authId);
  await userRef.delete();

  const infoRef = db.collection("infos").doc(authId);
  await infoRef.delete();

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
