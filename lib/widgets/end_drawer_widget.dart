import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/user_data.dart';
import 'package:which/views/created_screen.dart';
import 'package:which/views/delete_screen.dart';
import 'package:which/views/profile_screen.dart';
import 'package:which/views/regist_screen.dart';
import 'package:which/views/saved_screen.dart';
import 'package:which/views/setup_screen.dart';
import 'package:which/views/signin_screen.dart';
import 'package:which/views/signout_screen.dart';

class EndDrawerWidget extends HookConsumerWidget {
  const EndDrawerWidget({super.key, required this.myData});
  final UserData myData;

  List<Widget> _tiles(BuildContext context, UserData myData) {
    final bool anonymousFlg = myData.anonymousFlg;
    final List<Widget> tiles = [];
    tiles.add(
      const DrawerHeader(
        child: Center(
          child: Text(
            'アカウント',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
    if (anonymousFlg) {
      tiles.add(
        ListTile(
          title: const Text('サインイン'),
          onTap: () => context.push(SigninScreen.absolutePath),
        ),
      );
      tiles.add(
        ListTile(
          title: const Text('新規登録'),
          onTap: () => context.push(RegistScreen.absolutePath),
        ),
      );
    } else {
      tiles.add(
        ListTile(
          title: const Text('プロフィール'),
          onTap: myData.name.isEmpty && myData.image.isEmpty
              ? () => context.push(SetupScreen.absolutePath)
              : () => context.push(ProfileScreen.absolutePath),
        ),
      );
      tiles.add(
        ListTile(
          title: const Text('作成済み'),
          onTap: () => context.push(CreatedScreen.absolutePath),
        ),
      );
      tiles.add(
        ListTile(
          title: const Text('保存済み'),
          onTap: () => context.push(SavedScreen.absolutePath),
        ),
      );
      tiles.add(
        Divider(
          indent: 10,
          endIndent: 10,
          height: 20,
          thickness: 1.6,
          color: Colors.black.withOpacity(0.6),
        ),
      );
      tiles.add(
        ListTile(
          title: const Text('サインアウト'),
          onTap: () => context.push(SignoutScreen.absolutePath),
        ),
      );
      tiles.add(
        ListTile(
          title: const Text('アカウント削除'),
          onTap: () => context.push(DeleteScreen.absolutePath),
        ),
      );
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: _tiles(context, myData),
      ),
    );
  }
}
