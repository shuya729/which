import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/indexes.dart';
import 'package:which/providers/questions_provider.dart';

final indexesProvider = StateNotifierProvider<IndexesNotifier, Indexes>(
  (ref) => IndexesNotifier(ref),
);

class IndexesNotifier extends StateNotifier<Indexes> {
  IndexesNotifier(this.ref) : super(const Indexes());
  final StateNotifierProviderRef ref;

  void setBottom(int value) {
    state = state.copyWith(bottom: value);
  }

  void addBottom(int value) {
    state = state.copyWith(bottom: state.bottom + value);
  }

  Future<void> changeTop(int value) async {
    value = value % Indexes.limit;
    if (state.include(value)) {
      state = state.copyWith(top: value);
      if (state.length < 20) {
        await ref.read(questionsProvider.notifier).getQuestions();
      }
    }
  }
}
