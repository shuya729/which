import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:which/models/user_data.dart';

class UserService {
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');
  static DocumentReference doc([String? authId]) => collection.doc(authId);

  Future<void> set({
    required String authId,
    required bool isAnonymous,
  }) {
    return doc(authId).set(UserData.forSet(authId, isAnonymous));
  }

  Future<void> update(
    UserData userData, {
    String? name,
    String? image,
    bool? anonymousFlg,
  }) async {
    await doc(userData.authId)
        .update(userData.forUpdate(name, image, anonymousFlg));
  }

  Future<UserData?> get(String authId) async {
    if (authId.isEmpty) return null;
    final DocumentSnapshot snapshot = await doc(authId).get();
    if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return UserData.fromFirestore(data);
    } else {
      return null;
    }
  }
}
