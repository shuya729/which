export const deleteCollection = async (
  db: FirebaseFirestore.Firestore,
  collectionRef: FirebaseFirestore.CollectionReference,
  batchSize: number
): Promise<void> => {
  const query = collectionRef.limit(batchSize);
  const snapshot = await query.get();

  if (snapshot.empty) return;

  const batch = db.batch();
  snapshot.docs.forEach((doc) => {
    batch.delete(doc.ref);
  });

  await batch.commit();

  await deleteCollection(db, collectionRef, batchSize);
};
