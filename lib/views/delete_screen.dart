import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
  String get errorMessage => 'アカウント削除に失敗しました。';

  Future<bool> _getGoogle() async {
    if (kIsWeb) {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.addScope('https://www.googleapis.com/auth/userinfo.email');
      googleProvider
          .addScope('https://www.googleapis.com/auth/userinfo.profile');
      return await _continueWithProvider(googleProvider);
    } else {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: ['email', 'profile']).signInSilently();
      if (googleUser == null) return false;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _continueWithCredential(credential);
    }
  }

  Future<bool> _getApple() async {
    final AppleAuthProvider appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');
    appleProvider.addScope('name');
    return await _continueWithProvider(appleProvider);
  }

  Future<bool> _continueWithCredential(OAuthCredential credential) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception();
    await currentUser.reauthenticateWithCredential(credential);
    await currentUser.delete();
    return true;
  }

  Future<bool> _continueWithProvider(AuthProvider provider) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception();
    if (kIsWeb) {
      await currentUser.reauthenticateWithPopup(provider);
    } else {
      await currentUser.reauthenticateWithProvider(provider);
    }
    await currentUser.delete();
    return true;
  }

  @override
  Future<void> execute(ValueNotifier<String> asyncPath) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception();
    } else if (user.providerData[0].providerId == 'google.com') {
      final bool ret = await _getGoogle();
      if (ret) asyncPath.value = HomeScreen.absolutePath;
    } else if (user.providerData[0].providerId == 'apple.com') {
      final bool ret = await _getApple();
      if (ret) asyncPath.value = HomeScreen.absolutePath;
    } else {
      throw Exception();
    }
  }
}
