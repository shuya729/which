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
  String get errorMsg => 'サインアップに失敗しました。';
  @override
  Future<void> toOther(BuildContext context) async {
    await context.push(SigninScreen.absolutePath);
  }

  @override
  void afterDialog(BuildContext context, _) {
    if (context.mounted) context.go(SetupScreen.absolutePath);
  }

  @override
  Future<void> continueWithCredential(
    BuildContext context,
    OAuthCredential credential,
  ) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        if (context.mounted) showMsgBar(context, 'サインアップに失敗しました。');
      } else {
        await currentUser.linkWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        if (context.mounted) showMsgBar(context, 'このアカウントは既に登録されています。');
        throw 'unnotified-error';
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> continueWithProvider(
    BuildContext context,
    AuthProvider provider,
  ) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        if (context.mounted) showMsgBar(context, 'サインアップに失敗しました。');
      } else {
        if (kIsWeb) {
          await currentUser.linkWithPopup(provider);
        } else {
          await currentUser.linkWithProvider(provider);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        if (context.mounted) showMsgBar(context, 'このアカウントは既に登録されています。');
        throw 'unnotified-error';
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }
}
