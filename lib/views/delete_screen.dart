import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/utils/screen_base.dart';

class DeleteScreen extends ScreenBase {
  const DeleteScreen({super.key});

  @override
  String get title => 'アカウント削除';

  Future<void> _delete() async {
    await Future<void>.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return textTemp(childBuilder: (constraints) {
      return Column(
        children: [
          const Text('アカウントを削除しますか？\n全てのデータが削除されます。'),
          const SizedBox(height: 50),
          SizedBox(
            width: 220,
            child: ElevatedButton(
              onPressed: () => _delete(),
              child: const Text('アカウント削除'),
            ),
          ),
        ],
      );
    });
  }
}
