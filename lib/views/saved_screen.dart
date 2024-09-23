import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/question.dart';
import 'package:which/utils/screen_base.dart';

class SavedScreen extends ScreenBase {
  const SavedScreen({super.key});

  @override
  String get title => '保存済み';

  Future<List<Question>> _getSavedQuestions() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return <Question>[];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncSnapshot<List<Question>> savedQuestions =
        useFuture(_getSavedQuestions());
    if (savedQuestions.hasData) {
      final List<Question> questions = savedQuestions.data!;
      if (questions.isEmpty) {
        return dispTemp(msg: '保存済みの質問はありません。');
      } else {
        return textTemp(
          childBuilder: (constraints) {
            return ListView.builder(
              itemCount: savedQuestions.data!.length,
              itemBuilder: (context, index) {
                final Question question = savedQuestions.data![index];
                return ListTile(
                  title: Text(question.question),
                  subtitle: Text(
                      '回答1: ${question.answer1} / 回答2: ${question.answer2}'),
                );
              },
            );
          },
        );
      }
    } else {
      return loadingTemp();
    }
  }
}
