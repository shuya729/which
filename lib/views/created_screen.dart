import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/indexes.dart';
import 'package:which/models/question.dart';
import 'package:which/models/user_data.dart';
import 'package:which/services/firestore_service.dart';
import 'package:which/utils/screen_base.dart';

class CreatedScreen extends ScreenBase {
  const CreatedScreen({super.key});

  @override
  String get title => '作成済み';
  @override
  bool? get allowAnonymous => false;
  static const String absolutePath = '/created';
  static const String relativePath = 'created';

  Future<List<Question?>> initQuestions(
    UserData myData,
    ValueNotifier<List<Question?>> questions,
    ValueNotifier<Indexes> indexes,
  ) async {
    final FirestoreService firestoreService = FirestoreService();
    final List<Question> createds = await firestoreService.getCreateds(myData);
    questions.value = [...createds];
    indexes.value = indexes.value.loaded(createds.length);
    return createds;
  }

  Future<void> onPageChanged(
    int value,
    ValueNotifier<Indexes> indexes,
    UserData myData,
    ValueNotifier<List<Question?>> questions,
  ) async {
    try {
      indexes.value = indexes.value.changePage(value);
      if (indexes.value.canLoad()) {
        await getQuestions(myData, questions, indexes);
      }
    } catch (e) {
      print('onGetQuestions: $e');
    }
  }

  Future<List<Question?>> getQuestions(
    UserData myData,
    ValueNotifier<List<Question?>> questions,
    ValueNotifier<Indexes> indexes,
  ) async {
    indexes.value = indexes.value.loading();
    final FirestoreService firestoreService = FirestoreService();
    final List<Question> createds =
        await firestoreService.getCreateds(myData, last: questions.value.last);
    final List<Question?> preQuestions = questions.value;
    for (Question question in createds) {
      if (preQuestions.contains(question)) createds.remove(question);
    }
    questions.value = [...preQuestions, ...createds];
    indexes.value = indexes.value.loaded(createds.length);
    return createds;
  }

  Future<void> _refresh(
    BuildContext context,
    UserData myData,
    ValueNotifier<List<Question?>> questions,
    PageController pageController,
    ValueNotifier<Indexes> indexes,
    ValueNotifier<double> diff,
  ) async {
    pageController.jumpToPage(0);
    await showFutureLoading(
      context,
      refreshQuestions(myData, questions, indexes),
      errorValue: <Question?>[],
      errorMsg: 'データの取得に失敗しました。',
      afterDialog: (context, ret) {
        if (ret.isEmpty) {
          showMsgBar(context, '質問が見つかりませんでした。');
        }
      },
    );
    diff.value = 0;
  }

  Future<List<Question?>> refreshQuestions(
    UserData myData,
    ValueNotifier<List<Question?>> questions,
    ValueNotifier<Indexes> indexes,
  ) async {
    final FirestoreService firestoreService = FirestoreService();
    final List<Question> createds = await firestoreService.getCreateds(myData);
    questions.value = [...createds];
    indexes.value = Indexes().loaded(createds.length);
    return createds;
  }

  Future<void> _reload(
    BuildContext context,
    UserData myData,
    ValueNotifier<List<Question?>> questions,
    ValueNotifier<Indexes> indexes,
    PageController pageController,
  ) async {
    final int page = pageController.page?.round() ?? 0;
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInBack,
    );
    await showFutureLoading(
      context,
      getQuestions(myData, questions, indexes),
      errorValue: <Question?>[],
      errorMsg: 'データの取得に失敗しました。',
      afterDialog: (context, ret) {
        if (ret.isEmpty) {
          showMsgBar(context, '質問が見つかりませんでした。');
        }
      },
    );
  }

  void _listener(
    BuildContext context,
    UserData myData,
    PageController pageController,
    ValueNotifier<List<Question?>> questions,
    ValueNotifier<Indexes> indexes,
    ValueNotifier<double> diff,
  ) {
    if (pageController.hasClients) {
      final int page = pageController.page?.round() ?? 0;
      final double position =
          pageController.position.pixels / MediaQuery.of(context).size.height;
      if (page == indexes.value.top) {
        final double diffValue = page - position;
        if (diffValue > 0.1 && diff.value <= 0.1) {
          _refresh(context, myData, questions, pageController, indexes, diff);
        }
        diff.value = diffValue;
      } else if (page == indexes.value.bottom) {
        final diffValue = position - page;
        if (diffValue > 0.1 && diff.value <= 0.1) {
          _reload(context, myData, questions, indexes, pageController);
        }
        diff.value = diffValue;
      } else {
        diff.value = 0;
      }
    }
  }

  @override
  Widget userBuild(BuildContext context, WidgetRef ref, UserData myData) {
    final PageController pageController = usePageController();
    final ValueNotifier<List<Question?>> questions = useState([]);
    final ValueNotifier<Indexes> indexes = useState(const Indexes());
    final ValueNotifier<double> diff = useState(0);
    useEffect(() {
      listener() => _listener(
            context,
            myData,
            pageController,
            questions,
            indexes,
            diff,
          );
      pageController.addListener(listener);
      return () => pageController.removeListener(listener);
    }, [myData, pageController, questions, indexes, diff]);

    final future = useMemoized(
      () => showFutureLoading(
        context,
        initQuestions(myData, questions, indexes),
        errorValue: <Question?>[],
        errorMsg: '質問の取得に失敗しました。',
      ),
    );
    final AsyncSnapshot asyncSnapshot = useFuture(future);

    if (asyncSnapshot.connectionState == ConnectionState.done &&
        questions.value.isEmpty) {
      return dispTemp(msg: '$titleの質問はありません。');
    }

    return questionsTemp(
      myData: myData,
      itemCount: questions.value.length,
      pageController: pageController,
      questions: questions.value,
      indexes: indexes.value,
      diff: diff.value,
      onPageChanged: (value) => onPageChanged(
        value,
        indexes,
        myData,
        questions,
      ),
      refreshFunction: () => _refresh(
        context,
        myData,
        questions,
        pageController,
        indexes,
        diff,
      ),
      reloadFunciton: () => _reload(
        context,
        myData,
        questions,
        indexes,
        pageController,
      ),
      topBuilder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          width: double.infinity,
          height: max(40, constraints.maxHeight * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => context.pop(),
                style: IconButton.styleFrom(
                  iconSize: 18,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withOpacity(0.2),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const SizedBox(width: 42),
            ],
          ),
        );
      },
    );
  }
}
