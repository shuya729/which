import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:which/models/question.dart';
import 'package:which/models/question_id.dart';
import 'package:which/models/user_data.dart';
import 'package:which/services/question_service.dart';
import 'package:which/services/user_service.dart';

class SavedService {
  static CollectionReference collection(String authId) =>
      UserService.doc(authId).collection('saved');
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

  Future<void> delete({
    required UserData userData,
    required Question question,
  }) async {
    final DocumentReference doc =
        collection(userData.authId).doc(question.questionId);
    await doc.delete();
  }

  Stream<QuestionId?> getStream({
    required UserData userData,
    required Question question,
  }) async* {
    final Stream<DocumentSnapshot> snapshots =
        doc(userData.authId, question.questionId).snapshots();
    await for (final DocumentSnapshot snapshot in snapshots) {
      if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
        final Map<String, dynamic> data =
            snapshot.data() as Map<String, dynamic>;
        yield QuestionId.fromFirestore(data);
      } else {
        yield null;
      }
    }
  }

  Future<List<Question>> getSaveds({
    required UserData userData,
    Question? last,
  }) async {
    final Query query;
    if (last == null) {
      query = collection(userData.authId)
          .orderBy('creAt', descending: true)
          .limit(30);
    } else {
      query = collection(userData.authId)
          .orderBy('creAt', descending: true)
          .startAfter([last.creAt]).limit(20);
    }
    final QuerySnapshot snapshots = await query.get();
    final List<QuestionId> questionIds = <QuestionId>[];
    if (snapshots.docs.isEmpty) return <Question>[];
    for (final QueryDocumentSnapshot snapshot in snapshots.docs) {
      if (snapshot.exists &&
          snapshot.data() is Map<String, dynamic> &&
          snapshot.id != last?.questionId) {
        final Map<String, dynamic> data =
            snapshot.data() as Map<String, dynamic>;
        questionIds.add(QuestionId.fromFirestore(data));
      }
    }
    if (questionIds.isEmpty) return <Question>[];
    final QuestionService questionService = QuestionService();
    return await questionService.getQuestionsFromIds(questionIds);
  }
}
