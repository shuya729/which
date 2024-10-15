import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:which/models/contact.dart';
import 'package:which/models/question.dart';
import 'package:which/models/question_id.dart';
import 'package:which/models/report_question.dart';
import 'package:which/models/user_data.dart';
import 'package:which/models/vote.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  DocumentReference userRef(String authId) => userCollection.doc(authId);

  Future<UserData?> getUser(String authId) async {
    if (authId.isEmpty) return null;
    final DocumentSnapshot snapshot = await userRef(authId).get();
    if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return UserData.fromFirestore(data);
    } else {
      return null;
    }
  }

  Future<void> setUser(UserData userData) {
    final UserData data =
        userData.copyWith(creAt: DateTime.now(), updAt: DateTime.now());
    return userRef(userData.authId).set(data.toFirestore());
  }

  Future<void> updateUser(UserData userData) {
    final UserData data = userData.copyWith(updAt: DateTime.now());
    return userRef(userData.authId).update(data.toFirestore());
  }

  Future<void> updateProfile(UserData myData, String? name, String? imageUrl) {
    final UserData data = myData.copyWith(name: name, image: imageUrl);
    return updateUser(data);
  }

  CollectionReference get questionCollection =>
      _firestore.collection('questions');

  DocumentReference questionRef(Question question) =>
      questionCollection.doc(question.questionId);

  Future<void> addQuestion(Question question) {
    final DocumentReference doc = questionCollection.doc();
    final Question data = question.copyWith(
      questionId: doc.id,
      creAt: DateTime.now(),
      updAt: DateTime.now(),
    );
    return doc.set(data.toFirestore());
  }

  Future<void> updateQuestion(
    Question question, {
    bool incrementRead = false,
    bool incrementAnswer1 = false,
    bool incrementAnswer2 = false,
  }) {
    final Question data = question.copyWith(updAt: DateTime.now());
    return questionRef(question).update(
      data.toFirestore(
        incrementRead: incrementRead,
        incrementAnswer1: incrementAnswer1,
        incrementAnswer2: incrementAnswer2,
      ),
    );
  }

  Future<void> deleteQuestion(Question question) {
    return questionRef(question).delete();
  }

  Stream<Question?> getQuestionStream(Question question) async* {
    final Stream<DocumentSnapshot> snapshots =
        questionRef(question).snapshots();
    await for (final DocumentSnapshot snapshot in snapshots) {
      if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
        final Map<String, dynamic> data =
            snapshot.data() as Map<String, dynamic>;
        yield Question.fromFirestore(data);
      } else {
        yield null;
      }
    }
  }

  // 要変更
  Future<List<Question>> getQuestions(
    List<Question> questions, {
    String? id,
  }) async {
    Query query;
    if (questions.isNotEmpty) {
      query = questionCollection
          .orderBy('creAt', descending: true)
          .endBefore([questions.last.creAt]).limit(20);
    } else {
      query = questionCollection.orderBy('creAt', descending: true).limit(40);
    }
    if (id != null && id.isNotEmpty) {
      final ref = questionCollection.doc(id);
      final DocumentSnapshot snapshot = await ref.get();
      if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
        final Map<String, dynamic> data =
            snapshot.data() as Map<String, dynamic>;
        questions.add(Question.fromFirestore(data));
      }
    }
    final QuerySnapshot snapshots = await query.get();
    if (snapshots.docs.isEmpty) return questions;
    for (final QueryDocumentSnapshot doc in snapshots.docs) {
      if (doc.exists && doc.data() is Map<String, dynamic>) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        final Question question = Question.fromFirestore(data);
        if (!questions.any((e) => e.questionId == question.questionId)) {
          questions.add(question);
        }
      }
    }
    return questions;
  }

  Future<List<Question>> _getQuestionsFromIds(List<String> questionIds) async {
    final List<Question> questions = [];
    if (questionIds.isEmpty) return questions;
    final Query query =
        questionCollection.where('questionId', whereIn: questionIds);
    final QuerySnapshot snapshots = await query.get();
    if (snapshots.docs.isEmpty) return questions;
    for (final QueryDocumentSnapshot doc in snapshots.docs) {
      if (doc.exists && doc.data() is Map<String, dynamic>) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        questions.add(Question.fromFirestore(data));
      }
    }
    // // questionIdsの順番に並び替え
    final List<Question> sortedQuestions = [];
    for (final String questionId in questionIds) {
      if (questions.any((e) => e.questionId == questionId)) {
        final Question question =
            questions.firstWhere((e) => e.questionId == questionId);
        sortedQuestions.add(question);
      }
    }
    return sortedQuestions;
  }

  Future<List<Question>> getCreateds(UserData myData, {Question? last}) async {
    final Query<Object?> query;
    if (last != null) {
      query = questionCollection
          .where('authId', isEqualTo: myData.authId)
          .orderBy('creAt', descending: true)
          .endBefore([last.creAt]).limit(20);
    } else {
      query = questionCollection
          .where('authId', isEqualTo: myData.authId)
          .orderBy('creAt', descending: true)
          .limit(40);
    }
    final QuerySnapshot<Object?> snapshot = await query.get();
    if (snapshot.docs.isEmpty) return [];
    final List<Question> questions = [];
    for (final QueryDocumentSnapshot doc in snapshot.docs) {
      if (doc.exists && doc.data() is Map<String, dynamic>) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        questions.add(Question.fromFirestore(data));
      }
    }
    return questions;
  }

  CollectionReference readedCollection(UserData myData) =>
      userRef(myData.authId).collection('readed');

  Future<void> setReaded(UserData myData, Question question) {
    final DocumentReference doc =
        readedCollection(myData).doc(question.questionId);
    final QuestionId data = QuestionId.init(question.questionId, myData.authId);
    return doc.set(data.toFirestore(), SetOptions(merge: true));
  }

  Future<QuestionId?> getReaded(UserData myData, Question question) async {
    final DocumentSnapshot snapshot =
        await readedCollection(myData).doc(question.questionId).get();
    if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return QuestionId.fromFirestore(data);
    } else {
      return null;
    }
  }

  CollectionReference savedCollection(UserData myData) =>
      userRef(myData.authId).collection('saved');

  Future<void> setSaved(UserData myData, Question question) {
    final DocumentReference doc =
        savedCollection(myData).doc(question.questionId);
    final QuestionId data = QuestionId.init(question.questionId, myData.authId);
    return doc.set(data.toFirestore());
  }

  Future<void> deleteSaved(UserData myData, Question question) {
    return savedCollection(myData).doc(question.questionId).delete();
  }

  Stream<QuestionId?> getSavedStream(
      UserData myData, Question question) async* {
    final Stream<DocumentSnapshot> snapshots =
        savedCollection(myData).doc(question.questionId).snapshots();
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

  Future<List<Question>> getSaveds(UserData myData, {Question? last}) async {
    final Query<Object?> query;
    if (last != null) {
      query = savedCollection(myData)
          .orderBy('creAt', descending: true)
          .endBefore([last.creAt]).limit(20);
    } else {
      query =
          savedCollection(myData).orderBy('creAt', descending: true).limit(40);
    }
    final QuerySnapshot<Object?> snapshot = await query.get();
    if (snapshot.docs.isEmpty) return [];
    final List<String> questionIds = [];
    for (final QueryDocumentSnapshot doc in snapshot.docs) {
      if (doc.exists && doc.data() is Map<String, dynamic>) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        final QuestionId questionId = QuestionId.fromFirestore(data);
        questionIds.add(questionId.questionId);
      }
    }
    if (questionIds.isEmpty) return [];
    return _getQuestionsFromIds(questionIds);
  }

  CollectionReference votedCollection(UserData myData) =>
      userRef(myData.authId).collection('voted');

  Future<void> setVoted(UserData myData, Question question, int vote) async {
    if (vote != 1 && vote != 2) return;
    final DocumentReference doc =
        votedCollection(myData).doc(question.questionId);
    final Vote data = Vote.init(
      authId: myData.authId,
      questionId: question.questionId,
      vote: vote,
    );
    await doc.set(data.toFirestore());
  }

  Future<Vote?> getVoted(UserData myData, Question question) async {
    final DocumentSnapshot snapshot =
        await votedCollection(myData).doc(question.questionId).get();
    if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return Vote.fromFirestore(data);
    } else {
      return null;
    }
  }

  Stream<Vote?> getVotedStream(UserData myData, Question question) async* {
    final Stream<DocumentSnapshot> snapshots =
        votedCollection(myData).doc(question.questionId).snapshots();
    await for (final DocumentSnapshot snapshot in snapshots) {
      if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
        final Map<String, dynamic> data =
            snapshot.data() as Map<String, dynamic>;
        yield Vote.fromFirestore(data);
      } else {
        yield null;
      }
    }
  }

  DocumentReference reportQuestionRef(Question question, UserData myData) =>
      questionCollection
          .doc(question.questionId)
          .collection('reports')
          .doc(myData.authId);

  Future<void> reportQuestion(UserData myData, Question question) {
    final DocumentReference doc = reportQuestionRef(question, myData);
    final ReportQuestion reportQuestion = ReportQuestion(
      authId: myData.authId,
      questionId: question.questionId,
      creAt: DateTime.now(),
    );
    return doc.set(reportQuestion.toFirestore());
  }

  CollectionReference get contactCollection =>
      _firestore.collection('contacts');

  Future<void> addContact(Contact contact) {
    final DocumentReference doc = contactCollection.doc();
    final data = contact.copyWith(contactId: doc.id, creAt: DateTime.now());
    return doc.set(data.toFirestore());
  }
}
