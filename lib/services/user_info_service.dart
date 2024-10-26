import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:which/models/user_data.dart';
import 'package:which/models/user_info.dart';

class UserInfoService {
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('infos');
  static DocumentReference doc(String authId) => collection.doc(authId);

  Future<void> login({required UserData userData}) {
    return doc(userData.authId).set(
      UserInfo.forLogin(userData.authId, userData.anonymousFlg),
      SetOptions(merge: true),
    );
  }
}
