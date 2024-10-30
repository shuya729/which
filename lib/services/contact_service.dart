import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:which/models/contact.dart';

class ContactService {
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('contacts');
  static DocumentReference doc([String? contactId]) =>
      collection.doc(contactId);

  Future<void> set({
    required String uid,
    required String name,
    required String email,
    required int subject,
    required String content,
  }) async {
    final DocumentReference doc = collection.doc();
    await doc.set(
      Contact.forSet(
        doc.id,
        uid,
        name,
        email,
        subject,
        content,
      ),
    );
  }
}
