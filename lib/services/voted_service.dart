import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:which/models/question.dart';
import 'package:which/models/user_data.dart';
import 'package:which/models/vote.dart';
import 'package:which/services/user_service.dart';

class VotedService {
  static CollectionReference collection(String authId) =>
      UserService.doc(authId).collection('voted');
  static DocumentReference doc(String authId, [String? questionId]) =>
      collection(authId).doc(questionId);

  Future<void> set({
    required UserData userData,
    required Question question,
    required int vote,
  }) async {
    if (vote != 1 && vote != 2) return;
    final DocumentReference doc =
        collection(userData.authId).doc(question.questionId);
    await doc.set(
      Vote.forSet(question.questionId, userData.authId, vote),
      SetOptions(merge: true),
    );
  }

  Future<Vote?> get({
    required UserData userData,
    required Question question,
  }) async {
    final DocumentSnapshot snapshot =
        await doc(userData.authId, question.questionId).get();
    if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return Vote.fromFirestore(data);
    } else {
      return null;
    }
  }

  Stream<Vote?> getStream({
    required UserData userData,
    required Question question,
  }) async* {
    final Stream<DocumentSnapshot> snapshots =
        doc(userData.authId, question.questionId).snapshots();
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
}
