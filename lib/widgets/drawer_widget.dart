import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/user_data.dart';
import 'package:which/views/contact_screen.dart';
import 'package:which/views/license_screen.dart';
import 'package:which/views/privacy_screen.dart';
import 'package:which/views/term_screen.dart';

class DrawerWidget extends HookConsumerWidget {
  const DrawerWidget({super.key, required this.myData});
  final UserData myData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            child: Center(
              child: Text(
                'メニュー',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('利用規約'),
            onTap: () => context.push(TermScreen.absolutePath),
          ),
          ListTile(
            title: const Text('プライバシーポリシー'),
            onTap: () => context.push(PrivacyScreen.absolutePath),
          ),
          ListTile(
            title: const Text('ライセンス情報'),
            onTap: () => context.push(LicenseScreen.absolutePath),
          ),
          ListTile(
            title: const Text('お問い合わせ'),
            onTap: () => context.push(ContactScreen.absolutePath),
          ),
        ],
      ),
    );
  }
}
