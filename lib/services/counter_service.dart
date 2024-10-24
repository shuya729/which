import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:which/models/counter.dart';
import 'package:which/models/question.dart';
import 'package:which/services/question_service.dart';

class CounterService {
  static CollectionReference collection(String questionId) =>
      QuestionService.doc(questionId).collection('shards');
  static DocumentReference shardsDoc(String questionId) {
    final int shardId = Random().nextInt(Counter.shardsNum);
    return collection(questionId).doc(shardId.toString());
  }

  Future<void> increment(
    Question question, {
    bool incrementRead = false,
    bool incrementWatch = false,
    bool incrementAnswer1 = false,
    bool incrementAnswer2 = false,
  }) async {
    final DocumentReference doc = shardsDoc(question.questionId);
    await doc.set(
      Counter.forIncrement(
        question,
        incrementRead: incrementRead,
        incrementWatch: incrementWatch,
        incrementAnswer1: incrementAnswer1,
        incrementAnswer2: incrementAnswer2,
      ),
      SetOptions(merge: true),
    );
  }

  Stream<Counter?> getStream(Question question) async* {
    final Stream<QuerySnapshot> snapshots =
        collection(question.questionId).snapshots();
    await for (final QuerySnapshot snapshot in snapshots) {
      if (snapshot.docs.isNotEmpty) {
        final List<DocumentSnapshot> docs = snapshot.docs;
        yield Counter.fromDocs(docs);
      } else {
        yield null;
      }
    }
  }
}
