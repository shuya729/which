import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/utils/screen_base.dart';

class SigninScreen extends ScreenBase {
  const SigninScreen({super.key});

  @override
  String get title => 'サインイン';

  Future<void> _signin() async {
    await Future<void>.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return textTemp(childBuilder: (constraints) {
      return Column(
        children: [
          const Text('以下の方法でサインインしてください。'),
          const SizedBox(height: 50),
          SizedBox(
            width: 220,
            child: ElevatedButton(
              onPressed: () => _signin(),
              child: const Text('Googleでサインイン'),
            ),
          ),
          const SizedBox(height: 10),
          const Text('or'),
          const SizedBox(height: 10),
          SizedBox(
            width: 220,
            child: ElevatedButton(
              onPressed: () => _signin(),
              child: const Text('Appleでサインイン'),
            ),
          ),
        ],
      );
    });
  }
}
