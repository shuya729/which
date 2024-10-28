import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:which/models/terms.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> putIcon(String authId, Uint8List image) async {
    final Reference ref = _storage.ref('users/$authId/icon.jpg');
    await ref.putData(image, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }

  Future<List<Terms?>> getTerm(String termPath) async {
    final List<Terms?> terms = [];
    final Reference ref = _storage.ref('terms/term/$termPath');
    final Uint8List? data = await ref.getData();
    if (data == null) return terms;
    final String decoded = utf8.decode(data);
    final Map<String, dynamic> jsonData =
        jsonDecode(decoded) as Map<String, dynamic>;
    final List<dynamic> jsonList = jsonData['contents'] as List<dynamic>;
    for (final dynamic json in jsonList) {
      if (json is Map<String, dynamic>) terms.add(Terms.fromJson(json));
    }
    return terms;
  }

  Future<List<Terms?>> getPrivacy(String privacyPath) async {
    final List<Terms?> terms = [];
    final Reference ref = _storage.ref('terms/privacy/$privacyPath');
    final Uint8List? data = await ref.getData();
    if (data == null) return terms;
    final String decoded = utf8.decode(data);
    final Map<String, dynamic> jsonData =
        jsonDecode(decoded) as Map<String, dynamic>;
    final List<dynamic> jsonList = jsonData['contents'] as List<dynamic>;
    for (final dynamic json in jsonList) {
      if (json is Map<String, dynamic>) terms.add(Terms.fromJson(json));
    }
    return terms;
  }
}
