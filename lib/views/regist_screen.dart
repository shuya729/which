import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:which/views/setup_screen.dart';
import 'package:which/views/signin_screen.dart';

class RegistScreen extends SigninScreen {
  const RegistScreen({super.key});

  @override
  String get title => '新規登録';
  @override
  bool? get allowAnonymous => true;
  static const String absolutePath = '/regist';
  static const String relativePath = 'regist';

  @override
  String get sign => 'Sign up';
  @override
  String get other => 'サインイン';
  @override
  Future<void> toOther(BuildContext context) async {
    await context.push(SigninScreen.absolutePath);
  }

  @override
  void nextPage(ValueNotifier<String> asyncPath) {
    asyncPath.value = SetupScreen.absolutePath;
  }

  @override
  Future<bool> continueWithCredential(
    ValueNotifier<String> asyncMsg,
    OAuthCredential credential,
  ) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception();
      } else {
        await currentUser.linkWithCredential(credential);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        asyncMsg.value = 'このアカウントは既に登録されています。';
        return false;
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> continueWithProvider(
    ValueNotifier<String> asyncMsg,
    AuthProvider provider,
  ) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception();
      } else {
        if (kIsWeb) {
          await currentUser.linkWithPopup(provider);
        } else {
          await currentUser.linkWithProvider(provider);
        }
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        asyncMsg.value = 'このアカウントは既に登録されています。';
        return false;
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }
}
