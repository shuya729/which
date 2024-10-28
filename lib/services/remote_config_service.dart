import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:which/models/remote_config.dart';

class RemoteConfigService {
  static DocumentReference get doc =>
      FirebaseFirestore.instance.collection('configs').doc('config');

  Future<RemoteConfig> get() async {
    final DocumentSnapshot snapshot = await doc.get();
    if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return RemoteConfig.fromFirestore(data);
    } else {
      return RemoteConfig.init;
    }
  }
}
