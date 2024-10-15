import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> putIcon(String authId, Uint8List image) async {
    final Reference ref = _storage.ref('users/$authId/icon.jpg');
    await ref.putData(image, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }
}
