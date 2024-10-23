import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:which/models/question.dart';
import 'package:which/models/question_id.dart';
import 'package:which/models/user_data.dart';
import 'package:which/services/user_service.dart';

class ReadedService {
  static CollectionReference collection(String authId) =>
      UserService.doc(authId).collection('readed');
  static DocumentReference doc(String authId, [String? questionId]) =>
      collection(authId).doc(questionId);

  Future<void> set({
    required UserData userData,
    required Question question,
  }) async {
    final DocumentReference doc =
        collection(userData.authId).doc(question.questionId);
    await doc.set(
      QuestionId.forSet(userData.authId, question.questionId),
      SetOptions(merge: true),
    );
  }

  Future<QuestionId?> get({
    required UserData userData,
    required Question question,
  }) async {
    final DocumentSnapshot snapshot =
        await doc(userData.authId, question.questionId).get();
    if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return QuestionId.fromFirestore(data);
    } else {
      return null;
    }
  }
}
