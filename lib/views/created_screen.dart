import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/indexes.dart';
import 'package:which/models/question.dart';
import 'package:which/models/user_data.dart';
import 'package:which/services/question_service.dart';
import 'package:which/utils/screen_base.dart';

class CreatedScreen extends ScreenBase {
  const CreatedScreen({super.key});

  @override
  String get title => '作成済み';
  @override
  bool? get allowAnonymous => false;
  static const String absolutePath = '/created';
  static const String relativePath = 'created';
  @override
  bool get initLoading => true;

  Future<List<Question?>> initQuestions(
    UserData myData,
    ValueNotifier<List<Question?>> questions,
    ValueNotifier<Indexes> indexes,
  ) async {
    final QuestionService questionService = QuestionService();
    final List<Question> createds = await questionService.getCreateds(
      userData: myData,
    );
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
    } catch (_) {}
  }

  Future<List<Question?>> getQuestions(
    UserData myData,
    ValueNotifier<List<Question?>> questions,
    ValueNotifier<Indexes> indexes,
  ) async {
    indexes.value = indexes.value.loading();
    final QuestionService questionService = QuestionService();
    final List<Question> createds = await questionService.getCreateds(
      userData: myData,
      last: questions.value.last,
    );
    final List<Question?> preQuestions = questions.value;
    for (Question question in createds) {
      if (preQuestions.contains(question)) createds.remove(question);
    }
    questions.value = [...preQuestions, ...createds];
    indexes.value = indexes.value.loaded(createds.length);
    return createds;
  }

  Future<void> _refresh(
    ValueNotifier<bool> loading,
    ValueNotifier<String> asyncMsg,
    UserData myData,
    ValueNotifier<List<Question?>> questions,
    PageController pageController,
    ValueNotifier<Indexes> indexes,
    ValueNotifier<double> diff,
  ) async {
    pageController.jumpToPage(0);
    final List<Question?>? ret = await showFutureLoading(
      loading,
      asyncMsg,
      refreshQuestions(myData, questions, indexes),
      message: 'データの取得に失敗しました。',
    );
    if (ret != null && ret.isEmpty) asyncMsg.value = '質問が見つかりませんでした。';
    diff.value = 0;
  }

  Future<List<Question?>> refreshQuestions(
    UserData myData,
    ValueNotifier<List<Question?>> questions,
    ValueNotifier<Indexes> indexes,
  ) async {
    final QuestionService questionService = QuestionService();
    final List<Question> createds = await questionService.getCreateds(
      userData: myData,
    );
    questions.value = [...createds];
    indexes.value = Indexes().loaded(createds.length);
    return createds;
  }

  Future<void> _reload(
    ValueNotifier<bool> loading,
    ValueNotifier<String> asyncMst,
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
    final List<Question?>? ret = await showFutureLoading(
      loading,
      asyncMst,
      getQuestions(myData, questions, indexes),
      message: 'データの取得に失敗しました。',
    );
    if (ret != null && ret.isEmpty) asyncMst.value = '質問が見つかりませんでした。';
  }

  void _listener(
    double hieight,
    ValueNotifier<bool> loading,
    ValueNotifier<String> asyncMsg,
    UserData myData,
    PageController pageController,
    ValueNotifier<List<Question?>> questions,
    ValueNotifier<Indexes> indexes,
    ValueNotifier<double> diff,
  ) {
    if (pageController.hasClients) {
      final int page = pageController.page?.round() ?? 0;
      final double position = pageController.position.pixels / hieight;
      if (page == indexes.value.top) {
        final double diffValue = page - position;
        if (diffValue > 0.1 && diff.value <= 0.1) {
          _refresh(loading, asyncMsg, myData, questions, pageController,
              indexes, diff);
        }
        diff.value = diffValue;
      } else if (page == indexes.value.bottom) {
        final diffValue = position - page;
        if (diffValue > 0.1 && diff.value <= 0.1) {
          _reload(
              loading, asyncMsg, myData, questions, indexes, pageController);
        }
        diff.value = diffValue;
      } else {
        diff.value = 0;
      }
    }
  }

  @override
  Widget userBuild(
    BuildContext context,
    WidgetRef ref,
    UserData myData,
    ValueNotifier<bool> loading,
    ValueNotifier<String> asyncPath,
    ValueNotifier<String> asyncMsg,
  ) {
    final PageController pageController = usePageController();
    final ValueNotifier<List<Question?>> questions = useState([]);
    final ValueNotifier<Indexes> indexes = useState(const Indexes());
    final ValueNotifier<double> diff = useState(0);
    useEffect(() {
      listener() => _listener(
            MediaQuery.of(context).size.height,
            loading,
            asyncMsg,
            myData,
            pageController,
            questions,
            indexes,
            diff,
          );
      pageController.addListener(listener);
      return () => pageController.removeListener(listener);
    }, [myData, pageController, questions.value, indexes.value, diff.value]);

    final future = useMemoized(
      () => showFutureLoading(
        loading,
        asyncMsg,
        initQuestions(myData, questions, indexes),
        message: '質問の取得に失敗しました。',
      ),
    );
    final AsyncSnapshot asyncSnapshot = useFuture(future);

    if (asyncSnapshot.connectionState == ConnectionState.done &&
        questions.value.isEmpty) {
      return dispTemp(msg: '$titleの質問はありません。');
    }

    return questionsTemp(
      loading: loading.value,
      asyncMsg: asyncMsg,
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
        loading,
        asyncMsg,
        myData,
        questions,
        pageController,
        indexes,
        diff,
      ),
      reloadFunciton: () => _reload(
        loading,
        asyncMsg,
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
                  backgroundColor: Colors.white24,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
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
