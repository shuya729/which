import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:which/models/question.dart';
import 'package:which/models/question_id.dart';
import 'package:which/models/user_data.dart';
import 'package:which/services/question_service.dart';

class ReportQuestionService {
  static CollectionReference collection(String questionId) =>
      QuestionService.doc(questionId).collection('reports');
  static DocumentReference doc(String questionId, [UserData? userData]) =>
      collection(questionId).doc(userData?.authId);

  Future<void> set({
    required UserData userData,
    required Question question,
  }) async {
    final DocumentReference doc =
        collection(question.questionId).doc(userData.authId);
    await doc.set(
      QuestionId.forSet(userData.authId, question.questionId),
      SetOptions(merge: true),
    );
  }
}
