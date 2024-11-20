import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/question.dart';
import 'package:which/models/user_data.dart';
import 'package:which/services/question_service.dart';
import 'package:which/services/report_question_service.dart';

class QuestionBottomSheetWidget extends HookConsumerWidget {
  const QuestionBottomSheetWidget({
    super.key,
    required this.myData,
    required this.question,
    required this.asyncMsg,
  });
  final UserData myData;
  final Question question;
  final ValueNotifier<String> asyncMsg;

  Future<void> _reportQuestion(BuildContext context) async {
    Navigator.of(context).pop();
    try {
      final ReportQuestionService reportQuestionService =
          ReportQuestionService();
      await reportQuestionService.set(userData: myData, question: question);
      asyncMsg.value = '投稿を報告しました。';
    } catch (e) {
      asyncMsg.value = 'エラーが発生しました。';
    }
  }

  Future<void> _deleteQuestion(BuildContext context) async {
    Navigator.of(context).pop();
    try {
      final QuestionService questionService = QuestionService();
      await questionService.delete(question);
      asyncMsg.value = '投稿を削除しました。';
    } catch (e) {
      asyncMsg.value = 'エラーが発生しました。';
    }
  }

  // Future<void> _test(BuildContext context) async {
  //   Navigator.of(context).pop();
  //   try {} catch (e) {
  //     print(e);
  //   }
  // }

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
          // Card(
          //   clipBehavior: Clip.hardEdge,
          //   margin: const EdgeInsets.all(10),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          //   child: InkWell(
          //     onTap: () => _test(context),
          //     child: Container(
          //       height: 50,
          //       alignment: Alignment.center,
          //       child: const Text(
          //         'テスト機能',
          //         style: TextStyle(fontSize: 16),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
