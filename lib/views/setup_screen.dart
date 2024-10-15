import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:which/models/user_data.dart';
import 'package:which/services/firestore_service.dart';
import 'package:which/services/storage_service.dart';
import 'package:which/views/home_screen.dart';
import 'package:which/views/profile_screen.dart';

class SetupScreen extends ProfileScreen {
  const SetupScreen({super.key});

  @override
  String get title => 'プロフィール';
  static const String absolutePath = '/setup';
  static const String relativePath = 'setup';

  @override
  bool screenValidate(UserData myData) =>
      myData.name.isNotEmpty || myData.image.isNotEmpty;

  @override
  bool disabled(ValueNotifier<Uint8List?> imageData, bool sameName) =>
      imageData.value == null || sameName;

  @override
  void afterDialog(BuildContext context) {
    if (context.mounted) context.go(HomeScreen.absolutePath);
  }

  @override
  Future<void> save({
    required BuildContext context,
    required UserData myData,
    required TextEditingController nameController,
    required ValueNotifier<Uint8List?> imageData,
  }) async {
    final StorageService storageService = StorageService();
    final FirestoreService firestoreService = FirestoreService();
    final String name = nameController.text.trim();
    final Uint8List? image = imageData.value;
    if (image == null) {
      if (context.mounted) showMsgBar(context, 'アイコンを画像を選択されていません。');
      return;
    }
    final String imageUrl = await storageService.putIcon(myData.authId, image);
    await firestoreService.updateProfile(myData, name, imageUrl);
    imageData.value = null;
  }
}
