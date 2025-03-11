import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/circle_indexes.dart';
import 'package:which/providers/questions_provider.dart';

final indexesProvider = StateNotifierProvider<IndexesNotifier, CircleIndexes>(
  (ref) => IndexesNotifier(ref),
);

class IndexesNotifier extends StateNotifier<CircleIndexes> {
  IndexesNotifier(this.ref) : super(const CircleIndexes());
  final Ref ref;

  Future<void> changePage(int value) async {
    state = state.changePage(value);
    if (state.canLoad()) {
      await ref.read(questionsProvider.notifier).getQuestions(state.bottom);
    }
  }

  void init() {
    state = const CircleIndexes();
  }

  void loading() {
    state = state.loading();
  }

  void loaded(int length) {
    state = state.loaded(length);
  }
}
