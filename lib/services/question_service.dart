import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:which/models/question.dart';
import 'package:which/models/question_id.dart';
import 'package:which/models/user_data.dart';

class QuestionService {
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('questions');
  static DocumentReference doc([String? questionId]) =>
      collection.doc(questionId);

  Future<String> add({
    required UserData userData,
    required String quest,
    required String answer1,
    required String answer2,
  }) async {
    final DocumentReference doc = collection.doc();
    await doc.set(Question.forSet(
      doc.id,
      userData.anonymousFlg ? '' : userData.authId,
      quest,
      answer1,
      answer2,
    ));
    return doc.id;
  }

  Future<void> delete(Question question) async {
    await doc(question.questionId).delete();
  }

  Future<Question?> get(Question question) async {
    final DocumentSnapshot snapshot = await doc(question.questionId).get();
    if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return Question.fromFirestore(data);
    } else {
      return null;
    }
  }

  Future<List<Question>> getQuestionsFromIds(
    List<QuestionId> questionIds,
  ) async {
    final List<Question> questions = <Question>[];
    if (questionIds.isEmpty) return questions;
    final Query query = collection.where(
      'questionId',
      whereIn: questionIds
          .map((QuestionId questionId) => questionId.questionId)
          .toList(),
    );
    final QuerySnapshot snapshots = await query.get();
    if (snapshots.docs.isEmpty) return questions;
    for (final QueryDocumentSnapshot snapshot in snapshots.docs) {
      if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
        final Map<String, dynamic> data =
            snapshot.data() as Map<String, dynamic>;
        questions.add(Question.fromFirestore(data));
      }
    }

    final List<Question> sortedQuestions = <Question>[];
    for (final QuestionId questionId in questionIds) {
      final int index = questions.indexWhere(
        (Question question) => question.questionId == questionId.questionId,
      );
      if (index != -1) {
        final Question question = questions[index];
        sortedQuestions.add(question.copyWith(lastAt: questionId.creAt));
      }
    }
    return sortedQuestions;
  }

  Future<List<Question>> getCreateds({
    required UserData userData,
    Question? last,
  }) async {
    final Query query;
    if (last == null) {
      query = collection
          .where('authId', isEqualTo: userData.authId)
          .orderBy('creAt', descending: true)
          .limit(30);
    } else {
      query = collection
          .where('authId', isEqualTo: userData.authId)
          .orderBy('creAt', descending: true)
          .startAfter([last.lastAt]).limit(20);
    }
    final QuerySnapshot snapshots = await query.get();
    final List<Question> questions = <Question>[];
    if (snapshots.docs.isEmpty) return questions;
    for (final QueryDocumentSnapshot snapshot in snapshots.docs) {
      if (snapshot.exists &&
          snapshot.data() is Map<String, dynamic> &&
          snapshot.id != last?.questionId) {
        final Map<String, dynamic> data =
            snapshot.data() as Map<String, dynamic>;
        questions.add(Question.fromFirestore(data));
      }
    }
    return questions;
  }
}
