import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/question.dart';
import 'package:which/models/user_data.dart';
import 'package:which/services/firestore_service.dart';
import 'package:which/utils/screen_base.dart';
import 'package:which/views/home_screen.dart';

class CreatedScreen extends ScreenBase {
  const CreatedScreen({super.key});

  @override
  String get title => '作成済み';
  @override
  bool? get allowAnonymous => false;
  static const String absolutePath = '/created';
  static const String relativePath = 'created';

  Future<List<Question>> _getCreatedQuestions(
      BuildContext context, UserData myData) {
    final FirestoreService firestoreService = FirestoreService();
    return firestoreService.getCreateds(myData);
  }

  @override
  Widget userBuild(BuildContext context, WidgetRef ref, UserData myData) {
    final Future<List<Question>> future = useMemoized(
      () => showFutureLoading(
        context,
        _getCreatedQuestions(context, myData),
        errorValue: [],
        errorMsg: '質問の取得に失敗しました。',
      ),
    );
    final AsyncSnapshot<List<Question>> asyncSnapshot = useFuture(future);

    if (asyncSnapshot.hasData && asyncSnapshot.data!.isEmpty) {
      return dispTemp(msg: '作成済みの質問はありません。');
    }

    final List<Question> questions = asyncSnapshot.data ?? [];
    return listTemp(
      itemCount: questions.length,
      itemBuilder: (BoxConstraints constraints, int index) {
        final Question question = questions[index];
        return ListTile(
          // tileColor: Colors.blue,
          onTap: () => context.push(HomeScreen.createPath(question.questionId)),
          title: Text(question.quest),
          subtitle: Text(
            '回答1: ${question.answer1} / 回答2: ${question.answer2}',
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        );
      },
    );
  }
}
