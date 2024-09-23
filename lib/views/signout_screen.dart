import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/utils/screen_base.dart';

class SignoutScreen extends ScreenBase {
  const SignoutScreen({super.key});

  @override
  String get title => 'サインアウト';

  Future<void> _signout() async {
    await Future<void>.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return textTemp(childBuilder: (constraints) {
      return Column(
        children: [
          const Text('サインアウトしますか？\n一部の機能が使用できなくなります。'),
          const SizedBox(height: 50),
          SizedBox(
            width: 220,
            child: ElevatedButton(
              onPressed: () => _signout(),
              child: const Text('サインアウト'),
            ),
          ),
        ],
      );
    });
  }
}
