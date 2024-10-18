import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/question.dart';
import 'package:which/models/user_data.dart';
import 'package:which/services/firestore_service.dart';
import 'package:which/services/function_service.dart';
import 'package:which/utils/screen_base.dart';

class BottomSheetWidget extends HookConsumerWidget with ScreenBaseFunction {
  const BottomSheetWidget({
    super.key,
    required this.myData,
    required this.question,
  });
  final UserData myData;
  final Question question;

  Future<void> _reportQuestion(BuildContext context) async {
    Navigator.of(context).pop();
    final FirestoreService firestoreService = FirestoreService();
    await firestoreService.reportQuestion(myData, question).catchError(
      (_) {
        if (context.mounted) showMsgBar(context, '投稿の報告に失敗しました。');
      },
    );
    if (context.mounted) showMsgBar(context, '投稿を報告しました。');
  }

  Future<void> _deleteQuestion(BuildContext context) async {
    Navigator.of(context).pop();
    final FirestoreService firestoreService = FirestoreService();
    await firestoreService.deleteQuestion(question).catchError(
      (_) {
        if (context.mounted) showMsgBar(context, '投稿の削除に失敗しました。');
      },
    );
    if (context.mounted) showMsgBar(context, '投稿を削除しました。');
  }

  Future<void> _test(BuildContext context) async {
    Navigator.of(context).pop();
    try {
      print('\nstart');
      FunctionService functionService = FunctionService();
      final ret = await functionService.searchQuestions(input: '季節');
      print(ret.length);
      print(ret.first.quest);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 180,
      child: Column(
        children: [
          question.authId == myData.userId
              ? Card(
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () => _deleteQuestion(context),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: const Text(
                        '投稿を削除する',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              : Card(
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () => _reportQuestion(context),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: const Text(
                        '投稿を報告する',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
          Card(
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: () => _test(context),
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: const Text(
                  'テスト機能',
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
