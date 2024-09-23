import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/question.dart';
import 'package:which/utils/screen_base.dart';

class CreatedScreen extends ScreenBase {
  const CreatedScreen({super.key});

  @override
  String get title => '作成済み';

  Future<List<Question>> _getCreatedQuestions() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return <Question>[];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncSnapshot<List<Question>> createdQuestions =
        useFuture(_getCreatedQuestions());

    if (createdQuestions.hasData) {
      final List<Question> questions = createdQuestions.data!;
      if (questions.isEmpty) {
        return dispTemp(msg: '作成済みの質問はありません。');
      } else {
        return textTemp(
          childBuilder: (constraints) {
            return ListView.builder(
              itemCount: createdQuestions.data!.length,
              itemBuilder: (context, index) {
                final Question question = createdQuestions.data![index];
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
