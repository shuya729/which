import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/utils/screen_base.dart';
import 'package:which/views/home_screen.dart';

class NotfoundScreen extends ScreenBase {
  const NotfoundScreen({super.key});

  @override
  String get title => ''; // 使用しない
  static const String absolutePath = '/notfound';
  static const String relativePath = 'notfound';

  @override
  Widget baseBuild(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> loading,
    ValueNotifier<String> asyncPath,
    ValueNotifier<String> asyncMsg,
  ) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
          leading: IconButton(
            onPressed: () => context.go(HomeScreen.absolutePath),
            icon: Image.asset(
              'assets/system/bipick_logo.png',
              width: 28,
              height: 28,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'ご指定のページは見つかりませんでした。',
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => context.go(HomeScreen.absolutePath),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('ホームに戻る'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
