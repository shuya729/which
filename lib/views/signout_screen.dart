import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/user_data.dart';
import 'package:which/utils/screen_base.dart';
import 'package:which/views/home_screen.dart';

class SignoutScreen extends ScreenBase {
  const SignoutScreen({super.key});

  @override
  String get title => 'サインアウト';
  @override
  bool? get allowAnonymous => false;
  static const String absolutePath = '/signout';
  static const String relativePath = 'signout';

  String get text => 'サインアウト';
  String get description => 'サインアウトしますか？\n一部の機能が使用できなくなります。';
  String get errorMsg => 'サインアウトに失敗しました。';

  void afterDialog(BuildContext context) {
    if (context.mounted) context.go(HomeScreen.absolutePath);
  }

  Future<void> execute(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget userBuild(BuildContext context, WidgetRef ref, UserData myData) {
    return textTemp(
      builder: (BoxConstraints constraints) {
        return Column(
          children: [
            Text(description),
            const SizedBox(height: 50),
            SizedBox(
              width: 210,
              height: 33,
              child: OutlinedButton(
                onPressed: () => showFutureLoading(
                  context,
                  execute(context),
                  errorValue: null,
                  errorMsg: errorMsg,
                  afterDialog: afterDialog,
                ),
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
                child: Text(text),
              ),
            ),
          ],
        );
      },
    );
  }
}
