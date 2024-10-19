import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/circle_indexes.dart';
import 'package:which/models/question.dart';
import 'package:which/providers/indexes_provider.dart';
import 'package:which/services/function_service.dart';

final questionsProvider =
    StateNotifierProvider<QuestionsNotifier, List<Question?>>(
        (ref) => QuestionsNotifier(ref));

class QuestionsNotifier extends StateNotifier<List<Question?>> {
  QuestionsNotifier(this.ref)
      : super(List<Question?>.filled(CircleIndexes.limit, null));
  final StateNotifierProviderRef ref;
  final FunctionService _functionService = FunctionService();

  Future<List<Question?>> initQuestions({String? id}) async {
    final List<Question> questions =
        await _functionService.initQuestions(questionId: id);
    state = [...questions]..length = CircleIndexes.limit;
    ref.read(indexesProvider.notifier).loaded(questions.length);
    return questions;
  }

  Future<List<Question?>> getQuestions(int bottom) async {
    ref.read(indexesProvider.notifier).loading();
    final List<Question> questions = await _functionService.getQuestions();
    final List<Question?> newQuestions = state;
    for (int i = 0; i < questions.length; i++) {
      final index = (bottom + i + 1) % CircleIndexes.limit;
      newQuestions[index] = questions[i];
    }
    state = [...newQuestions]..length = CircleIndexes.limit;
    ref.read(indexesProvider.notifier).loaded(questions.length);
    return questions;
  }

  Future<List<Question?>> searchQuestions({required String input}) async {
    input = input.trim();
    if (input.isEmpty) return [];
    ref.read(indexesProvider.notifier).init();
    final List<Question> questions =
        await _functionService.searchQuestions(input: input);
    state = [...questions]..length = CircleIndexes.limit;
    ref.read(indexesProvider.notifier).loaded(questions.length);
    return questions;
  }

  Future<List<Question?>> refreshQuestions() async {
    ref.read(indexesProvider.notifier).init();
    final List<Question> questions = await _functionService.initQuestions();
    state = [...questions]..length = CircleIndexes.limit;
    ref.read(indexesProvider.notifier).loaded(questions.length);
    return questions;
  }
}
