import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/circle_indexes.dart';
import 'package:which/models/question.dart';
import 'package:which/models/user_data.dart';
import 'package:which/providers/indexes_provider.dart';
import 'package:which/providers/questions_provider.dart';
import 'package:which/providers/user_stream_provider.dart';
import 'package:which/utils/screen_base.dart';
import 'package:which/views/create_screen.dart';
import 'package:which/widgets/drawer_widget.dart';
import 'package:which/widgets/end_drawer_widget.dart';

class HomeScreen extends ScreenBase {
  const HomeScreen({super.key, required this.id});
  final String? id;

  @override
  String get title => ''; // 使用しない
  static const String absolutePath = '/';
  static const String relativePath = '/';
  static String createPath(String questionId) => '/?id=$questionId';

  Future<void> _onPageChanged(
    int value,
    IndexesNotifier indexesNotifier,
  ) async {
    try {
      await indexesNotifier.changePage(value);
    } catch (e) {
      print('onGetQuestions: $e');
    }
  }

  Future<void> _onSubmit(
    BuildContext context,
    String value,
    QuestionsNotifier questionsNotifier,
    PageController pageController,
  ) async {
    if (value.isEmpty) return;
    pageController.jumpToPage(0);
    await showFutureLoading(
      context,
      questionsNotifier.searchQuestions(input: value),
      errorValue: <Question?>[],
      errorMsg: '検索に失敗しました。',
      afterDialog: (context, ret) {
        if (ret.isEmpty) {
          showMsgBar(context, '質問が見つかりませんでした。');
        }
      },
    );
  }

  Future<void> _refreshQuestions(
    BuildContext context,
    QuestionsNotifier questionsNotifier,
    PageController pageController,
    TextEditingController textController,
    ValueNotifier<double> diff,
  ) async {
    pageController.jumpToPage(0);
    textController.clear();
    await showFutureLoading(
      context,
      questionsNotifier.refreshQuestions(),
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

  Future<void> _reloadQuestions(
    BuildContext context,
    QuestionsNotifier questionsNotifier,
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
      questionsNotifier.getQuestions(page),
      errorValue: <Question?>[],
      errorMsg: 'データの取得に失敗しました。',
      afterDialog: (context, ret) {
        if (ret.isEmpty) {
          showMsgBar(context, '質問が見つかりませんでした。');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuestionsNotifier questionsNotifier =
        ref.read(questionsProvider.notifier);
    final AsyncValue<UserData> myData = ref.watch(userStreamProvider);
    return myData.when<Widget>(
      data: (UserData data) {
        if (allowAnonymous == true && !data.anonymousFlg) {
          return dispTemp(msg: '不正な画面遷移です。');
        } else if (allowAnonymous == false && data.anonymousFlg) {
          return dispTemp(msg: 'ログインが必要です。');
        } else {
          final future =
              useMemoized(() => questionsNotifier.initQuestions(id: id));
          final AsyncSnapshot<void> asyncFuture = useFuture(future);
          if (asyncFuture.hasError) {
            return dispTemp(msg: 'データの取得に失敗しました。');
          } else if (asyncFuture.connectionState == ConnectionState.done) {
            return userBuild(context, ref, data);
          } else {
            return loadingTemp();
          }
        }
      },
      loading: () => loadingTemp(),
      error: (_, __) => dispTemp(msg: '認証時にエラーが発生しました。'),
    );
  }

  @override
  Widget userBuild(BuildContext context, WidgetRef ref, UserData myData) {
    final PageController pageController = usePageController();
    final TextEditingController textController = useTextEditingController();
    final QuestionsNotifier questionsNotifier =
        ref.read(questionsProvider.notifier);
    final List<Question?> questions = ref.watch(questionsProvider);
    final IndexesNotifier indexesNotifier = ref.read(indexesProvider.notifier);
    final CircleIndexes indexes = ref.watch(indexesProvider);
    final ValueNotifier<double> diff = useState(0);
    useEffect(() {
      pageController.addListener(() {
        if (pageController.hasClients) {
          final int page = pageController.page?.round() ?? 0;
          final double position = pageController.position.pixels /
              MediaQuery.of(context).size.height;
          if (page == indexes.top) {
            final double diffValue = page - position;
            if (diffValue > 0.1 && diff.value <= 0.1) {
              _refreshQuestions(
                context,
                questionsNotifier,
                pageController,
                textController,
                diff,
              );
            }
            diff.value = diffValue;
          } else if (page == indexes.bottom) {
            final diffValue = position - page;
            if (diffValue > 0.1 && diff.value <= 0.1) {
              _reloadQuestions(
                context,
                questionsNotifier,
                pageController,
              );
            }
            diff.value = diffValue;
          } else {
            diff.value = 0;
          }
        }
      });
      return null;
    }, [pageController]);

    return questionsTemp(
      myData: myData,
      pageController: pageController,
      questions: questions,
      indexes: indexes,
      diff: diff.value,
      onPageChanged: (value) => _onPageChanged(value, indexesNotifier),
      refreshFunction: () => _refreshQuestions(
        context,
        questionsNotifier,
        pageController,
        textController,
        diff,
      ),
      reloadFunciton: () => _reloadQuestions(
        context,
        questionsNotifier,
        pageController,
      ),
      topBuilder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          width: double.infinity,
          height: max(40, constraints.maxHeight * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
                style: IconButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withOpacity(0.2),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: TextField(
                    controller: textController,
                    onSubmitted: (value) => _onSubmit(
                      context,
                      value,
                      questionsNotifier,
                      pageController,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.3,
                    ),
                    cursorColor: Colors.white.withOpacity(1),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      hintText: '検索',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      suffixIcon: const Icon(Icons.search),
                      suffixIconColor: Colors.white.withOpacity(0.8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.white.withOpacity(1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: CircleAvatar(
                  radius: 16.5,
                  backgroundColor: Colors.white,
                  foregroundImage: myData.image.isEmpty
                      ? const AssetImage('assets/system/person.png')
                      : NetworkImage(myData.image),
                ),
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
      bottomWidgetBuilder: (BuildContext context, BoxConstraints constraints) {
        return ElevatedButton.icon(
          onPressed: () {
            context.push(CreateScreen.absolutePath);
          },
          label: const Text('作成'),
          icon: const Icon(Icons.add),
          style: ElevatedButton.styleFrom(
            elevation: 2,
            foregroundColor: Colors.white,
            backgroundColor: Colors.black.withOpacity(0.8),
            minimumSize: const Size(110, 45),
            maximumSize: const Size(240, 50),
            fixedSize: Size(
              constraints.maxWidth * 0.3,
              constraints.maxHeight * 0.07,
            ),
            textStyle: const TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      drawer: DrawerWidget(myData: myData),
      endDrawer: EndDrawerWidget(myData: myData),
    );
  }
}
