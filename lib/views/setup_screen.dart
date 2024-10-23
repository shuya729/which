import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:which/models/user_data.dart';
import 'package:which/services/storage_service.dart';
import 'package:which/services/user_service.dart';
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
  Future<void> save({
    required ValueNotifier<String> asyncPath,
    required ValueNotifier<String> asyncMsg,
    required UserData myData,
    required TextEditingController nameController,
    required ValueNotifier<Uint8List?> imageData,
  }) async {
    final StorageService storageService = StorageService();
    final UserService userService = UserService();
    final String name = nameController.text.trim();
    final Uint8List? image = imageData.value;
    if (image == null) {
      asyncMsg.value = 'アイコンを画像が選択されていません。';
      return;
    }
    final String imageUrl = await storageService.putIcon(myData.authId, image);
    await userService.update(myData, name: name, image: imageUrl);
    imageData.value = null;
    asyncPath.value = HomeScreen.absolutePath;
  }
}
