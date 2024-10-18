import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/user_data.dart';
import 'package:which/utils/screen_base.dart';
import 'package:which/views/home_screen.dart';
import 'package:which/views/regist_screen.dart';

class SigninScreen extends ScreenBase {
  const SigninScreen({super.key});

  @override
  String get title => 'サインイン';
  @override
  bool? get allowAnonymous => true;
  static const String absolutePath = '/signin';
  static const String relativePath = 'signin';

  String get sign => 'Sign in';
  String get other => '新規登録';
  String get errorMsg => 'サインインに失敗しました。';

  Future<void> toOther(BuildContext context) async {
    await context.push(RegistScreen.absolutePath);
  }

  void afterDialog(BuildContext context, _) async {
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
      await continueWithProvider(context, googleProvider);
    } else {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: ['email', 'profile']).signIn();
      if (googleUser == null) throw Exception('unnotified-error');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      if (context.mounted) await continueWithCredential(context, credential);
    }
  }

  Future<void> _getApple(BuildContext context) async {
    final AppleAuthProvider appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');
    appleProvider.addScope('name');
    await continueWithProvider(context, appleProvider);
  }

  Future<void> continueWithCredential(
    BuildContext context,
    OAuthCredential credential,
  ) async {
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> continueWithProvider(
    BuildContext context,
    AuthProvider provider,
  ) async {
    if (kIsWeb) {
      await FirebaseAuth.instance.signInWithPopup(provider);
    } else {
      await FirebaseAuth.instance.signInWithProvider(provider);
    }
  }

  @override
  Widget userBuild(BuildContext context, WidgetRef ref, UserData myData) {
    return textTemp(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            const Text('以下の方法でサインインしてください。'),
            const SizedBox(height: 50),
            SizedBox(
              width: 210,
              height: 33,
              child: OutlinedButton.icon(
                onPressed: () => showFutureLoading(
                  context,
                  _getGoogle(context),
                  errorValue: null,
                  errorMsg: errorMsg,
                  afterDialog: afterDialog,
                ),
                icon: Image.asset(
                  'assets/system/google_logo.png',
                  width: 20,
                  height: 20,
                ),
                label: Text('$sign with Google'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 14),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 21, vertical: 3.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: Colors.grey.shade600),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text('or'),
            const SizedBox(height: 15),
            SizedBox(
              width: 210,
              height: 33,
              child: OutlinedButton.icon(
                onPressed: () => showFutureLoading(
                  context,
                  _getApple(context),
                  errorValue: null,
                  errorMsg: errorMsg,
                  afterDialog: afterDialog,
                ),
                icon: Image.asset(
                  'assets/system/apple_logo.png',
                  width: 20,
                  height: 20,
                ),
                label: Text('$sign with Apple'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 14),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 21, vertical: 3.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: Colors.grey.shade600),
                ),
              ),
            ),
            const SizedBox(height: 60),
            Divider(color: Colors.grey.shade600),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => toOther(context),
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
              child: Text('$otherはこちら'),
            ),
          ],
        );
      },
    );
  }
}
