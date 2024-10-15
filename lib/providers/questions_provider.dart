import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/indexes.dart';
import 'package:which/models/question.dart';
import 'package:which/providers/indexes_provider.dart';
import 'package:which/services/function_service.dart';

final questionsProvider =
    StateNotifierProvider<QuestionsNotifier, List<Question?>>(
        (ref) => QuestionsNotifier(ref));

class QuestionsNotifier extends StateNotifier<List<Question?>> {
  QuestionsNotifier(this.ref)
      : super(List<Question?>.filled(Indexes.limit, null));
  final StateNotifierProviderRef ref;
  final FunctionService _functionService = FunctionService();
  bool _isLoading = false;

  Future<void> initQuestions({String? id}) async {
    if (_isLoading) return;
    print('initQuestions');
    _isLoading = true;
    try {
      final List<Question> questions =
          await _functionService.initQuestions(questionId: id);
      state = [...questions]..length = Indexes.limit;
      ref.read(indexesProvider.notifier).setBottom(questions.length - 1);
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      rethrow;
    }
  }

  Future<void> getQuestions() async {
    if (_isLoading) return;
    print('getQuestions');
    _isLoading = true;
    try {
      final List<Question> questions = await _functionService.getQuestions();
      final Indexes indexes = ref.read(indexesProvider);
      final List<Question?> newQuestions = state;
      for (int i = 0; i < questions.length; i++) {
        final index = (indexes.bottom + i + 1) % Indexes.limit;
        newQuestions[index] = questions[i];
      }
      state = [...newQuestions]..length = Indexes.limit;
      ref.read(indexesProvider.notifier).addBottom(questions.length);
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      rethrow;
    }
  }

  Future<void> searchQuestions({required String input}) async {
    if (_isLoading || input.isEmpty) return;
    print('searchQuestions');
    _isLoading = true;
    state = []..length = Indexes.limit;
    try {
      final List<Question> questions =
          await _functionService.searchQuestions(input: input);
      state = [...questions]..length = Indexes.limit;
      ref.read(indexesProvider.notifier).setBottom(questions.length - 1);
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      rethrow;
    }
  }
}
