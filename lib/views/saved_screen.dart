import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/question.dart';
import 'package:which/models/user_data.dart';
import 'package:which/utils/screen_base.dart';

class SavedScreen extends ScreenBase {
  const SavedScreen({super.key});

  @override
  String get title => '保存済み';
  @override
  bool? get allowAnonymous => false;
  static const String absolutePath = '/saved';
  static const String relativePath = 'saved';

  Future<List<Question>> _getSavedQuestions() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return <Question>[];
  }

  @override
  Widget userBuild(BuildContext context, WidgetRef ref, UserData myData) {
    final future = useMemoized(
      () => showFutureLoading<List<Question>>(
        context,
        _getSavedQuestions(),
        errorValue: [],
        errorMsg: '質問の取得に失敗しました。',
      ),
    );
    final AsyncSnapshot<List<Question>> asyncSnapshot = useFuture(future);

    if (asyncSnapshot.hasData && asyncSnapshot.data!.isEmpty) {
      return dispTemp(msg: '保存済みの質問はありません。');
    }

    final List<Question> questions = asyncSnapshot.data ?? [];
    return listTemp(
      itemCount: questions.length,
      itemBuilder: (BoxConstraints constraints, int index) {
        final Question question = questions[index];
        return ListTile(
          title: Text(question.quest),
          subtitle: Text('回答1: ${question.answer1} / 回答2: ${question.answer2}'),
        );
      },
    );
  }
}
