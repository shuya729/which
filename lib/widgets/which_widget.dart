import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:which/models/color_set.dart';
import 'package:which/models/counter.dart';
import 'package:which/models/question.dart';
import 'package:which/models/question_id.dart';
import 'package:which/models/user_data.dart';
import 'package:which/models/vote.dart';
import 'package:which/services/counter_service.dart';
import 'package:which/services/question_service.dart';
import 'package:which/services/saved_service.dart';
import 'package:which/services/user_service.dart';
import 'package:which/services/voted_service.dart';
import 'package:which/services/watched_service.dart';
import 'package:which/views/users_screen.dart';
import 'package:which/widgets/question_bottom_sheet_widget.dart';
import 'package:which/widgets/center_widget.dart';
import 'package:which/widgets/side_widget.dart';
import 'package:which/widgets/user_bottom_sheet_widget.dart';

class WhichWidget extends HookConsumerWidget {
  const WhichWidget({
    super.key,
    required this.myData,
    required this.question,
    required this.asyncMsg,
  });
  final UserData myData;
  final Question question;
  final ValueNotifier<String> asyncMsg;

  Future<void> _init(
    final ValueNotifier<ColorSet> colorSet,
    final PageController pageController,
    final ValueNotifier<int> voted,
  ) async {
    if (pageController.hasClients) {
      colorSet.value = ColorSet.set();
      pageController.jumpToPage(1);
      voted.value = 0;
    }
    try {
      final CounterService counterService = CounterService();
      await counterService.increment(question, incrementRead: true);
    } catch (e) {
      asyncMsg.value = 'エラーが発生しました。';
    }
  }

  Future<void> _onPageChanged(
    final int value,
    final ValueNotifier<int> voted,
  ) async {
    try {
      if (voted.value != 0 || value == 1) return;
      if (value == 0) voted.value = 2;
      if (value == 2) voted.value = 1;
      final WatchedService watchedService = WatchedService();
      final CounterService counterService = CounterService();
      await watchedService.set(userData: myData, question: question);
      await counterService.increment(question, incrementWatch: true);
    } catch (e) {
      asyncMsg.value = 'エラーが発生しました。';
    }
  }

  Future<Question?> _getQuestion() async {
    try {
      final QuestionService questionService = QuestionService();
      return await questionService.get(question);
    } catch (e) {
      asyncMsg.value = 'エラーが発生しました。';
      return null;
    }
  }

  Stream<Counter?> _getCounterStream() async* {
    try {
      final CounterService counterService = CounterService();
      final Stream<Counter?> stream = counterService.getStream(question);
      await for (final Counter? snapshot in stream) {
        yield snapshot;
      }
    } catch (e) {
      asyncMsg.value = 'エラーが発生しました。';
    }
  }

  Future<UserData?> _getUser() async {
    try {
      final UserService userService = UserService();
      return await userService.get(question.authId);
    } catch (e) {
      asyncMsg.value = 'エラーが発生しました。';
      return null;
    }
  }

  Future<void> _save(bool asyncSaved) async {
    try {
      final SavedService savedService = SavedService();
      if (myData.anonymousFlg) {
        asyncMsg.value = 'ログインが必要です。';
        return;
      } else if (asyncSaved) {
        await savedService.delete(userData: myData, question: question);
      } else {
        await savedService.set(userData: myData, question: question);
      }
    } catch (e) {
      asyncMsg.value = 'エラーが発生しました。';
    }
  }

  Stream<bool> _getSavedStream() async* {
    try {
      final SavedService savedService = SavedService();
      final Stream<QuestionId?> stream =
          savedService.getStream(userData: myData, question: question);
      await for (final QuestionId? snapshot in stream) {
        yield snapshot != null;
      }
    } catch (e) {
      asyncMsg.value = 'エラーが発生しました。';
    }
  }

  Future<void> _vote(
    final ValueNotifier<int> voted,
    final bool? asyncVoted,
  ) async {
    try {
      if (voted.value == 0 || asyncVoted != false) return;
      final VotedService votedService = VotedService();
      final CounterService counterService = CounterService();
      await votedService.set(
          userData: myData, question: question, vote: voted.value);
      if (voted.value == 1) {
        await counterService.increment(question, incrementAnswer1: true);
      } else if (voted.value == 2) {
        await counterService.increment(question, incrementAnswer2: true);
      }
    } catch (e) {
      asyncMsg.value = 'エラーが発生しました。';
    }
  }

  Stream<bool> _getVotedStream() async* {
    try {
      final VotedService votedService = VotedService();
      final Stream<Vote?> stream = votedService.getStream(
        userData: myData,
        question: question,
      );
      await for (final Vote? snapshot in stream) {
        yield snapshot != null;
      }
    } catch (e) {
      asyncMsg.value = 'エラーが発生しました。';
    }
  }

  Future<void> _showQuestionBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Colors.grey.shade100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return QuestionBottomSheetWidget(
          myData: myData,
          question: question,
          asyncMsg: asyncMsg,
        );
      },
    );
  }

  Future<void> _showUserBottomSheet(
      BuildContext context, UserData userData) async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.grey.shade100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return UserBottomSheetWidget(
          userData: userData,
          asyncMsg: asyncMsg,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<ColorSet> colorSet = useState(ColorSet.set());
    final PageController pageController = usePageController(initialPage: 1);
    final Future<Question?> futureQuestion =
        useMemoized(() => _getQuestion(), [question]);
    final Question asyncQuestion = useFuture(futureQuestion).data ?? question;
    // final Question asyncQuestion = // サンプル用
    //     (useFuture(futureQuestion).data ?? question).copyWith(
    //   quest: '男女の友情は成立する？',
    //   answer1: '成立する',
    //   answer2: '成立しない',
    // );
    final Stream<Counter?> streamCounter =
        useMemoized(() => _getCounterStream(), [question]);
    final Counter? asyncCounter = useStream(streamCounter).data;
    // final Counter? asyncCounter = useStream(streamCounter).data?.copyWith( // サンプル用
    //       answer1: 28,
    //       answer2: 53,
    //     );
    final Future<UserData?> futureUser =
        useMemoized(() => _getUser(), [question]);
    final UserData? asyncUser = useFuture(futureUser).data;
    final Stream<bool> streamSaved =
        useMemoized(() => _getSavedStream(), [myData, question]);
    final bool asyncSaved = useStream(streamSaved).data ?? false;
    final Stream<bool> streamVoted =
        useMemoized(() => _getVotedStream(), [myData, question]);
    final bool? asyncVoted = useStream(streamVoted).data;
    final ValueNotifier<int> voted = useState(0);
    useEffect(() {
      _init(colorSet, pageController, voted);
      return null;
    }, [question, myData]);
    useEffect(() {
      _vote(voted, asyncVoted);
      return null;
    }, [myData, voted.value, asyncVoted]);

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView(
          scrollDirection: Axis.horizontal,
          controller: pageController,
          onPageChanged: (value) => _onPageChanged(value, voted),
          children: [
            SideWidget(
              myData: myData,
              question: asyncQuestion,
              counter: asyncCounter,
              isLeft: true,
              colorSet: colorSet.value,
              pageController: pageController,
              voted: asyncVoted ?? false,
            ),
            CenterWidget(
              myData: myData,
              question: asyncQuestion,
              colorSet: colorSet.value,
              pageController: pageController,
            ),
            SideWidget(
              myData: myData,
              question: asyncQuestion,
              counter: asyncCounter,
              isLeft: false,
              colorSet: colorSet.value,
              pageController: pageController,
              voted: asyncVoted ?? false,
            ),
          ],
        ),
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  const Spacer(flex: 8),
                  Container(
                    height: constraints.maxHeight * 0.17,
                    alignment: Alignment.topCenter,
                    child: Card(
                      color: Colors.white,
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        width: constraints.maxWidth,
                        constraints: BoxConstraints(
                          maxWidth: 600,
                          minHeight: constraints.maxHeight * 0.1,
                        ),
                        child: AutoSizeText(
                          asyncQuestion.quest,
                          textAlign: TextAlign.center,
                          minFontSize: 10,
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 50),
                  Container(
                    height: constraints.maxHeight * 0.13,
                    constraints: const BoxConstraints(
                      minHeight: 76,
                      maxWidth: 900,
                    ),
                    width: constraints.maxWidth * 0.9,
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 76,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          asyncUser == null || asyncUser.anonymousFlg
                              ? const SizedBox.shrink()
                              : TextButton.icon(
                                  onPressed: () => context.push(
                                    UsersScreen.absolutePath(asyncUser.authId),
                                  ),
                                  onLongPress: () =>
                                      _showUserBottomSheet(context, asyncUser),
                                  icon: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.black45,
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.white,
                                      foregroundImage: asyncUser.image.isEmpty
                                          ? const AssetImage(
                                              'assets/system/person.png')
                                          : NetworkImage(asyncUser.image),
                                    ),
                                  ),
                                  label: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        asyncUser.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          height: 1,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${asyncQuestion.creAt.year}/${asyncQuestion.creAt.month}/${asyncQuestion.creAt.day}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 1,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextButton.styleFrom(
                                    elevation: 0,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 5,
                                    ),
                                    minimumSize: const Size(150, 54),
                                    maximumSize: const Size(300, 54),
                                    backgroundColor: Colors.white24,
                                    foregroundColor: Colors.white,
                                    fixedSize:
                                        Size(constraints.maxWidth * 0.45, 54),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              (asyncVoted != true)
                                  ? const SizedBox(height: 25)
                                  : Container(
                                      height: 25,
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        '回答済み',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => _save(asyncSaved),
                                    icon: Icon(
                                      asyncSaved
                                          ? Icons.bookmark
                                          : Icons.bookmark_outline,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.white24,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Share.shareUri(
                                        Uri.parse(
                                          'https://bipick.net/?id=${asyncQuestion.questionId}',
                                        ),
                                        sharePositionOrigin: Rect.fromCenter(
                                          center: Offset.zero,
                                          width: 0,
                                          height: 0,
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.ios_share),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.white24,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        _showQuestionBottomSheet(context),
                                    icon: const Icon(Icons.more_vert),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.white24,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 12),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
