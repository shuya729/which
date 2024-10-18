import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:which/views/home_screen.dart';
import 'package:which/views/signout_screen.dart';

class DeleteScreen extends SignoutScreen {
  const DeleteScreen({super.key});

  @override
  String get title => 'アカウント削除';
  @override
  bool? get allowAnonymous => false;
  static const String absolutePath = '/delete';
  static const String relativePath = 'delete';

  @override
  String get text => 'アカウント削除';
  @override
  String get description => 'アカウントを削除しますか？\n全てのデータが削除されます。';
  @override
  void afterDialog(BuildContext context, _) {
    if (context.mounted) context.go(HomeScreen.absolutePath);
  }

  Future<void> _getGoogle(BuildContext context) async {
    if (kIsWeb) {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.addScope('https://www.googleapis.com/auth/userinfo.email');
      googleProvider
          .addScope('https://www.googleapis.com/auth/userinfo.profile');
      await _continueWithProvider(context, googleProvider);
    } else {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: ['email', 'profile']).signInSilently();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      if (context.mounted) await _continueWithCredential(context, credential);
    }
  }

  Future<void> _getApple(BuildContext context) async {
    final AppleAuthProvider appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');
    appleProvider.addScope('name');
    await _continueWithProvider(context, appleProvider);
  }

  Future<void> _continueWithCredential(
    BuildContext context,
    OAuthCredential credential,
  ) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (context.mounted) showMsgBar(context, 'アカウント削除に失敗しました。');
    } else {
      await currentUser.reauthenticateWithCredential(credential);
      await currentUser.delete();
    }
  }

  Future<void> _continueWithProvider(
    BuildContext context,
    AuthProvider provider,
  ) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (context.mounted) showMsgBar(context, 'アカウント削除に失敗しました。');
    } else {
      if (kIsWeb) {
        await currentUser.reauthenticateWithPopup(provider);
      } else {
        await currentUser.reauthenticateWithProvider(provider);
      }
      await currentUser.delete();
    }
  }

  @override
  Future<void> execute(BuildContext context) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (context.mounted) showMsgBar(context, 'アカウント削除に失敗しました。');
    } else if (user.providerData[0].providerId == 'google.com') {
      await _getGoogle(context);
    } else if (user.providerData[0].providerId == 'apple.com') {
      await _getApple(context);
    } else {
      if (context.mounted) showMsgBar(context, 'アカウント削除に失敗しました。');
    }
  }
}
