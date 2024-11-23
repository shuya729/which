import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/user_data.dart';
import 'package:which/views/users_screen.dart';

class UserBottomSheetWidget extends HookConsumerWidget {
  const UserBottomSheetWidget({
    super.key,
    required this.userData,
    required this.asyncMsg,
  });

  final UserData userData;
  final ValueNotifier<String> asyncMsg;

  Future<void> _goUsers(BuildContext context) async {
    await context.push(UsersScreen.absolutePath(userData.authId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 320,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black45,
              child: CircleAvatar(
                radius: 27,
                backgroundColor: Colors.white,
                foregroundImage: userData.image.isEmpty
                    ? const AssetImage('assets/system/person.png')
                    : NetworkImage(userData.image),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              userData.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 38),
          Card(
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: () => _goUsers(context),
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: const Text(
                  'ユーザーの質問を見る',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
