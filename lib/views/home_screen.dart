import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:which/models/color_set.dart';
import 'package:which/models/indexes.dart';
import 'package:which/models/question.dart';
import 'package:which/models/question_id.dart';
import 'package:which/models/user_data.dart';
import 'package:which/models/vote.dart';
import 'package:which/providers/indexes_provider.dart';
import 'package:which/providers/questions_provider.dart';
import 'package:which/providers/user_stream_provider.dart';
import 'package:which/services/firestore_service.dart';
import 'package:which/services/function_service.dart';
import 'package:which/utils/screen_base.dart';
import 'package:which/utils/wave_clipper.dart';
import 'package:which/views/contact_screen.dart';
import 'package:which/views/create_screen.dart';
import 'package:which/views/created_screen.dart';
import 'package:which/views/delete_screen.dart';
import 'package:which/views/license_screen.dart';
import 'package:which/views/privacy_screen.dart';
import 'package:which/views/profile_screen.dart';
import 'package:which/views/regist_screen.dart';
import 'package:which/views/saved_screen.dart';
import 'package:which/views/setup_screen.dart';
import 'package:which/views/signin_screen.dart';
import 'package:which/views/signout_screen.dart';
import 'package:which/views/term_screen.dart';

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
      await indexesNotifier.changeTop(value);
    } catch (_) {}
  }

  Future<void> _onSubmit(
    BuildContext context,
    String value,
    QuestionsNotifier questionsNotifier,
    PageController pageController,
  ) async {
    await showFutureLoading(
      context,
      questionsNotifier.searchQuestions(input: value),
      errorValue: null,
      errorMsg: '検索に失敗しました。',
      afterDialog: (context) => pageController.jumpToPage(0),
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
    final Indexes indexes = ref.watch(indexesProvider);
    print('indexes: ${indexes.top}, ${indexes.bottom}');

    // return Scaffold(
    //   resizeToAvoidBottomInset: false,
    //   drawerEnableOpenDragGesture: false,
    //   endDrawerEnableOpenDragGesture: false,
    //   body: Stack(
    //     fit: StackFit.expand,
    //     children: [
    //       PageView.builder(
    //         scrollDirection: Axis.vertical,
    //         physics: const AlwaysScrollableScrollPhysics(),
    //         onPageChanged: (value) => _onPageChanged(value, indexesNotifier),
    //         itemBuilder: (context, index) {
    //           final int pageIndex = index % Indexes.limit;
    //           final Question? question = questions[pageIndex];
    //           if (pageIndex == indexes.bottom || question == null) {
    //             return null;
    //             // } else if(pageIndex % 20 == 17) {
    //             //   // 広告
    //             //   return const SizedBox.shrink();
    //           } else {
    //             return WhichWidget(myData: myData, question: question);
    //           }
    //         },
    //       ),
    //       SafeArea(
    //         child: LayoutBuilder(
    //           builder: (context, constraints) {
    //             return Column(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Container(
    //                   height: constraints.maxHeight * 0.08,
    //                   constraints: const BoxConstraints(minHeight: 45),
    //                   alignment: Alignment.center,
    //                   padding: const EdgeInsets.symmetric(horizontal: 5),
    //                   child: SizedBox(
    //                     width: double.infinity,
    //                     height: max(40, constraints.maxHeight * 0.05),
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                       children: [
    //                         IconButton(
    //                           icon: const Icon(Icons.menu),
    //                           onPressed: () =>
    //                               Scaffold.of(context).openDrawer(),
    //                           style: IconButton.styleFrom(
    //                             foregroundColor: Colors.white,
    //                             backgroundColor: Colors.white.withOpacity(0.2),
    //                           ),
    //                         ),
    //                         const SizedBox(width: 10),
    //                         Flexible(
    //                           child: ConstrainedBox(
    //                             constraints:
    //                                 const BoxConstraints(maxWidth: 500),
    //                             child: TextField(
    //                               controller: textController,
    //                               onSubmitted: (value) => _onSubmit(
    //                                 context,
    //                                 value,
    //                                 questionsNotifier,
    //                                 pageController,
    //                               ),
    //                               style: const TextStyle(
    //                                 fontSize: 16,
    //                                 height: 1.3,
    //                               ),
    //                               cursorColor: Colors.white.withOpacity(1),
    //                               decoration: InputDecoration(
    //                                 isDense: true,
    //                                 contentPadding: const EdgeInsets.symmetric(
    //                                   horizontal: 10,
    //                                   vertical: 5,
    //                                 ),
    //                                 hintText: '検索',
    //                                 hintStyle: TextStyle(
    //                                   color: Colors.white.withOpacity(0.8),
    //                                 ),
    //                                 filled: true,
    //                                 fillColor: Colors.white.withOpacity(0.2),
    //                                 suffixIcon: const Icon(Icons.search),
    //                                 suffixIconColor:
    //                                     Colors.white.withOpacity(0.8),
    //                                 enabledBorder: OutlineInputBorder(
    //                                   borderSide: BorderSide(
    //                                     width: 2,
    //                                     color: Colors.white.withOpacity(0.6),
    //                                   ),
    //                                 ),
    //                                 focusedBorder: OutlineInputBorder(
    //                                   borderSide: BorderSide(
    //                                     width: 2,
    //                                     color: Colors.white.withOpacity(1),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                         const SizedBox(width: 10),
    //                         IconButton(
    //                           onPressed: () =>
    //                               Scaffold.of(context).openEndDrawer(),
    //                           icon: CircleAvatar(
    //                             radius: 16.5,
    //                             backgroundColor: Colors.white,
    //                             foregroundImage: myData.image.isEmpty
    //                                 ? const AssetImage(
    //                                     'assets/system/person.png')
    //                                 : NetworkImage(myData.image),
    //                           ),
    //                           style: IconButton.styleFrom(
    //                             padding: EdgeInsets.zero,
    //                             backgroundColor: Colors.white.withOpacity(0.2),
    //                             foregroundColor: Colors.white,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //                 const Spacer(flex: 80),
    //                 Container(
    //                   height: constraints.maxHeight * 0.12,
    //                   constraints: const BoxConstraints(minHeight: 65),
    //                   alignment: Alignment.center,
    //                   child: ElevatedButton.icon(
    //                     onPressed: () {
    //                       context.push(CreateScreen.absolutePath);
    //                     },
    //                     label: const Text('作成'),
    //                     icon: const Icon(Icons.add),
    //                     style: ElevatedButton.styleFrom(
    //                       elevation: 2,
    //                       foregroundColor: Colors.white,
    //                       backgroundColor: Colors.black.withOpacity(0.8),
    //                       minimumSize: const Size(110, 45),
    //                       maximumSize: const Size(240, 50),
    //                       fixedSize: Size(
    //                         constraints.maxWidth * 0.3,
    //                         constraints.maxHeight * 0.07,
    //                       ),
    //                       textStyle: const TextStyle(fontSize: 18),
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(10),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             );
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    //   drawer: DrawerWidget(myData: myData),
    //   endDrawer: EndDrawerWidget(myData: myData),
    // );

    return questionsTemp(
      pageController: pageController,
      myData: myData,
      questions: questions,
      indexes: indexes,
      onPageChanged: (value) => _onPageChanged(value, indexesNotifier),
      topBuilder: (constraints) {
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
      bottomBuilder: (constraints) {
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

class WhichWidget extends HookConsumerWidget with ScreenBaseFunction {
  const WhichWidget({super.key, required this.myData, required this.question});
  final UserData myData;
  final Question question;

  Future<void> _init() async {
    final FirestoreService firestoreService = FirestoreService();
    final QuestionId? readed =
        await firestoreService.getReaded(myData, question);
    await firestoreService.setReaded(myData, question);
    if (readed != null) return;
    await firestoreService.updateQuestion(question, incrementRead: true);
  }

  Future<void> _onPageChanged(
    BuildContext context,
    int value,
    ValueNotifier<int> vote,
  ) async {
    if (vote.value != 0 || value == 1) return;
    if (value == 0) {
      vote.value = 2;
    } else if (value == 2) {
      vote.value = 1;
    }
    final FirestoreService firestoreService = FirestoreService();
    final Vote? voted = await firestoreService.getVoted(myData, question);
    if (voted != null) return;
    if (context.mounted) await _addVote(context, vote.value);
    await _voteQuestion(vote.value);
  }

  Stream<Question> _getQuestionStream() async* {
    final FirestoreService firestoreService = FirestoreService();
    final Stream<Question?> stream =
        firestoreService.getQuestionStream(question);
    await for (final Question? snapshot in stream) {
      if (snapshot != null) {
        yield snapshot;
      } else {
        yield question;
      }
    }
  }

  Future<UserData?> _getUser() async {
    final FirestoreService firestoreService = FirestoreService();
    return await firestoreService.getUser(question.authId);
  }

  Future<void> _saveQuestion(BuildContext context, bool asyncSaved) async {
    final FirestoreService firestoreService = FirestoreService();
    if (myData.anonymousFlg) {
      showMsgBar(context, 'ログインが必要です。');
      return;
    } else if (asyncSaved) {
      await firestoreService.deleteSaved(myData, question).catchError(
        (_) {
          if (context.mounted) showMsgBar(context, '保存解除に失敗しました。');
        },
      );
    } else {
      await firestoreService.setSaved(myData, question).catchError(
        (_) {
          if (context.mounted) showMsgBar(context, '保存に失敗しました。');
        },
      );
    }
  }

  Stream<bool> _getSavedStream() async* {
    final FirestoreService firestoreService = FirestoreService();
    final Stream<QuestionId?> stream =
        firestoreService.getSavedStream(myData, question);
    await for (final QuestionId? snapshot in stream) {
      yield snapshot != null;
    }
  }

  Future<void> _voteQuestion(int vote) async {
    final FirestoreService firestoreService = FirestoreService();
    if (vote == 1) {
      await firestoreService.updateQuestion(question, incrementAnswer1: true);
    } else if (vote == 2) {
      await firestoreService.updateQuestion(question, incrementAnswer2: true);
    }
  }

  Future<void> _addVote(BuildContext context, int vote) async {
    final FirestoreService firestoreService = FirestoreService();
    await firestoreService.setVoted(myData, question, vote).catchError(
      (_) {
        if (context.mounted) showMsgBar(context, '回答に失敗しました。');
      },
    );
  }

  Stream<bool> _getVotedStream() async* {
    final FirestoreService firestoreService = FirestoreService();
    final Stream<Vote?> stream =
        firestoreService.getVotedStream(myData, question);
    await for (final Vote? snapshot in stream) {
      yield snapshot != null;
    }
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Colors.blueGrey.shade50,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return BottomSheetWidget(myData: myData, question: question);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorSet colorSet = useState(ColorSet.set()).value;
    final PageController pageController = usePageController(initialPage: 1);
    final Stream<Question> streamQuestion =
        useMemoized(() => _getQuestionStream());
    final Question asyncQuestion = useStream(streamQuestion).data ?? question;
    final Future<UserData?> futureUser = useMemoized(() => _getUser());
    final UserData? asyncUser = useFuture(futureUser).data;
    final Stream<bool> streamSaved = useMemoized(() => _getSavedStream());
    final bool asyncSaved = useStream(streamSaved).data ?? false;
    final ValueNotifier<int> vote = useState(0);
    final Stream<bool> streamVoted = useMemoized(() => _getVotedStream());
    final bool asyncVoted = useStream(streamVoted).data ?? false;
    useEffect(() {
      _init();
      return null;
    }, []);

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView(
          scrollDirection: Axis.horizontal,
          controller: pageController,
          onPageChanged: (value) => _onPageChanged(context, value, vote),
          children: [
            SideWidget(
              myData: myData,
              question: asyncQuestion,
              isLeft: true,
              colorSet: colorSet,
              pageController: pageController,
              voted: asyncVoted,
            ),
            CenterWidget(
              myData: myData,
              question: asyncQuestion,
              colorSet: colorSet,
              pageController: pageController,
              voted: asyncVoted,
            ),
            SideWidget(
              myData: myData,
              question: asyncQuestion,
              isLeft: false,
              colorSet: colorSet,
              pageController: pageController,
              voted: asyncVoted,
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
                          maxWidth: 780,
                          minHeight: constraints.maxHeight * 0.1,
                        ),
                        child: AutoSizeText(
                          asyncQuestion.quest,
                          textAlign: TextAlign.center,
                          minFontSize: 10,
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 50),
                  Container(
                    height: constraints.maxHeight * 0.13,
                    constraints: const BoxConstraints(
                      minHeight: 54,
                      maxWidth: 900,
                    ),
                    width: constraints.maxWidth * 0.9,
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        asyncUser == null
                            ? const SizedBox.shrink()
                            : TextButton.icon(
                                onPressed: null,
                                icon: CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      Colors.black.withOpacity(0.6),
                                  child: CircleAvatar(
                                    radius: 18.4,
                                    backgroundColor: Colors.white,
                                    foregroundImage: asyncUser.image.isEmpty
                                        ? const AssetImage(
                                            'assets/system/person.png')
                                        : NetworkImage(asyncUser.image),
                                  ),
                                ),
                                label: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    const SizedBox(height: 4),
                                    Text(
                                      '${asyncQuestion.creAt.year}/${asyncQuestion.creAt.month}/${asyncQuestion.creAt.day}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1,
                                        color: Colors.black.withOpacity(0.6),
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
                                  backgroundColor:
                                      Colors.white.withOpacity(0.2),
                                  foregroundColor: Colors.white,
                                  fixedSize:
                                      Size(constraints.maxWidth * 0.45, 54),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  _saveQuestion(context, asyncSaved),
                              icon: Icon(
                                asyncSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_outline,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                foregroundColor: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Share.shareUri(
                                  Uri.parse(
                                    'https://which-464.web.app/?id=${asyncQuestion.questionId}',
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
                                backgroundColor: Colors.white.withOpacity(0.2),
                                foregroundColor: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _showBottomSheet(context),
                              icon: const Icon(Icons.more_vert),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
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

class CenterWidget extends HookConsumerWidget {
  const CenterWidget({
    super.key,
    required this.myData,
    required this.question,
    required this.colorSet,
    required this.pageController,
    required this.voted,
  });
  final UserData myData;
  final Question question;
  final ColorSet colorSet;
  final PageController pageController;
  final bool voted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                color: colorSet.leftColor,
                alignment: Alignment.centerRight,
                child: ClipPath(
                  clipper: const WaveClipper(correct: true),
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Container(
                      color: colorSet.rightColor,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: colorSet.rightColor,
                alignment: Alignment.centerLeft,
                child: ClipPath(
                  clipper: const WaveClipper(correct: false),
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Container(
                      color: colorSet.leftColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  const Spacer(flex: 8),
                  const Spacer(flex: 17),
                  Container(
                    height: constraints.maxHeight * 0.22,
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: constraints.maxWidth * 0.7,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: InkWell(
                        mouseCursor: SystemMouseCursors.click,
                        onTap: () => pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          constraints: const BoxConstraints(maxWidth: 780),
                          child: AutoSizeText(
                            question.answer1,
                            minFontSize: 10,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight * 0.06,
                    constraints: const BoxConstraints(minHeight: 34),
                    width: constraints.maxWidth * 0.95,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          icon: const Icon(Icons.arrow_back_ios),
                          iconSize: 20,
                          style: IconButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            foregroundColor: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        !voted
                            ? const SizedBox.shrink()
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
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
                        IconButton(
                          onPressed: () => pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          icon: const Icon(Icons.arrow_forward_ios),
                          iconSize: 20,
                          style: IconButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            foregroundColor: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight * 0.22,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: constraints.maxWidth * 0.7,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: InkWell(
                        mouseCursor: SystemMouseCursors.click,
                        onTap: () => pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          constraints: const BoxConstraints(maxWidth: 780),
                          child: AutoSizeText(
                            question.answer2,
                            minFontSize: 10,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 13),
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

class SideWidget extends HookConsumerWidget {
  const SideWidget({
    super.key,
    required this.myData,
    required this.question,
    required this.isLeft,
    required this.colorSet,
    required this.pageController,
    required this.voted,
  });
  final UserData myData;
  final Question question;
  final bool isLeft;
  final ColorSet colorSet;
  final PageController pageController;
  final bool voted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color backColor = isLeft ? colorSet.leftColor : colorSet.rightColor;
    final ValueNotifier<int> count =
        useState(isLeft ? question.answer2Count : question.answer1Count);
    final ValueNotifier<int> total =
        useState(question.answer1Count + question.answer2Count);
    return Container(
      color: backColor,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                const Spacer(flex: 8),
                const Spacer(flex: 17),
                Container(
                  height: constraints.maxHeight * 0.22,
                  alignment: Alignment.center,
                  child: Container(
                    width: constraints.maxWidth * 0.7,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      constraints: const BoxConstraints(maxWidth: 780),
                      child: AutoSizeText(
                        isLeft ? question.answer1 : question.answer2,
                        minFontSize: 10,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: constraints.maxHeight * 0.06,
                  constraints: const BoxConstraints(minHeight: 34),
                  width: constraints.maxWidth * 0.95,
                  alignment:
                      isLeft ? Alignment.centerRight : Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      if (isLeft) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    icon: isLeft
                        ? const Icon(Icons.arrow_forward_ios)
                        : const Icon(Icons.arrow_back_ios),
                    iconSize: 20,
                    style: IconButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      foregroundColor: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
                Container(
                  height: constraints.maxHeight * 0.22,
                  alignment: Alignment.topCenter,
                  child: AnimatedOpacity(
                    opacity: voted ? 1 : 0,
                    duration: const Duration(milliseconds: 600),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 0,
                              margin: EdgeInsets.symmetric(
                                horizontal: constraints.maxWidth * 0.015,
                              ),
                              width: constraints.maxWidth * 0.07,
                              constraints: const BoxConstraints(maxWidth: 30),
                            ),
                            Container(
                              width: constraints.maxWidth * 0.35,
                              constraints: BoxConstraints(
                                maxWidth: 140,
                                maxHeight: constraints.maxHeight * 0.15,
                              ),
                              child: AutoSizeText(
                                count.value == total.value
                                    ? '100'
                                    : (count.value / total.value * 100)
                                        .toStringAsFixed(1),
                                minFontSize: 30,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 60,
                                  fontWeight: FontWeight.w600,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: constraints.maxWidth * 0.015,
                                vertical: constraints.maxHeight * 0.015,
                              ),
                              width: constraints.maxWidth * 0.07,
                              constraints: BoxConstraints(
                                maxWidth: 30,
                                maxHeight: constraints.maxHeight * 0.12,
                              ),
                              child: AutoSizeText(
                                '%',
                                minFontSize: 22,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: constraints.maxWidth * 0.5,
                          constraints: BoxConstraints(
                            maxWidth: 200,
                            maxHeight: constraints.maxHeight * 0.07,
                          ),
                          alignment: Alignment.topCenter,
                          child: AutoSizeText(
                            '${count.value} p',
                            minFontSize: 10,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              fontFeatures: const [
                                FontFeature.tabularFigures()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 13),
                const Spacer(flex: 12),
              ],
            );
          },
        ),
      ),
    );
  }
}

class DrawerWidget extends HookConsumerWidget {
  const DrawerWidget({super.key, required this.myData});
  final UserData myData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                'メニュー',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('利用規約'),
            onTap: () => context.push(TermScreen.absolutePath),
          ),
          ListTile(
            title: const Text('プライバシーポリシー'),
            onTap: () => context.push(PrivacyScreen.absolutePath),
          ),
          ListTile(
            title: const Text('ライセンス情報'),
            onTap: () => context.push(LicenseScreen.absolutePath),
          ),
          ListTile(
            title: const Text('お問い合わせ'),
            onTap: () => context.push(ContactScreen.absolutePath),
          ),
        ],
      ),
    );
  }
}

class EndDrawerWidget extends HookConsumerWidget {
  const EndDrawerWidget({super.key, required this.myData});
  final UserData myData;

  List<Widget> _tiles(BuildContext context, UserData myData) {
    final bool anonymousFlg = myData.anonymousFlg;
    final List<Widget> tiles = [];
    tiles.add(
      const DrawerHeader(
        child: Center(
          child: Text(
            'アカウント',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
    if (anonymousFlg) {
      tiles.add(
        ListTile(
          title: const Text('サインイン'),
          onTap: () => context.push(SigninScreen.absolutePath),
        ),
      );
      tiles.add(
        ListTile(
          title: const Text('新規登録'),
          onTap: () => context.push(RegistScreen.absolutePath),
        ),
      );
    } else {
      tiles.add(
        ListTile(
          title: const Text('プロフィール'),
          onTap: myData.name.isEmpty && myData.image.isEmpty
              ? () => context.push(SetupScreen.absolutePath)
              : () => context.push(ProfileScreen.absolutePath),
        ),
      );
      tiles.add(
        ListTile(
          title: const Text('作成済み'),
          onTap: () => context.push(CreatedScreen.absolutePath),
        ),
      );
      tiles.add(
        ListTile(
          title: const Text('保存済み'),
          onTap: () => context.push(SavedScreen.absolutePath),
        ),
      );
      tiles.add(
        Divider(
          indent: 10,
          endIndent: 10,
          height: 20,
          thickness: 1.6,
          color: Colors.black.withOpacity(0.6),
        ),
      );
      tiles.add(
        ListTile(
          title: const Text('サインアウト'),
          onTap: () => context.push(SignoutScreen.absolutePath),
        ),
      );
      tiles.add(
        ListTile(
          title: const Text('アカウント削除'),
          onTap: () => context.push(DeleteScreen.absolutePath),
        ),
      );
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: _tiles(context, myData),
      ),
    );
  }
}

class BottomSheetWidget extends HookConsumerWidget with ScreenBaseFunction {
  const BottomSheetWidget({
    super.key,
    required this.myData,
    required this.question,
  });
  final UserData myData;
  final Question question;

  Future<void> _reportQuestion(BuildContext context) async {
    Navigator.of(context).pop();
    final FirestoreService firestoreService = FirestoreService();
    await firestoreService.reportQuestion(myData, question).catchError(
      (_) {
        if (context.mounted) showMsgBar(context, '投稿の報告に失敗しました。');
      },
    );
    if (context.mounted) showMsgBar(context, '投稿を報告しました。');
  }

  Future<void> _deleteQuestion(BuildContext context) async {
    Navigator.of(context).pop();
    final FirestoreService firestoreService = FirestoreService();
    await firestoreService.deleteQuestion(question).catchError(
      (_) {
        if (context.mounted) showMsgBar(context, '投稿の削除に失敗しました。');
      },
    );
    if (context.mounted) showMsgBar(context, '投稿を削除しました。');
  }

  Future<void> _test(BuildContext context) async {
    Navigator.of(context).pop();
    try {
      print('\nstart');
      FunctionService functionService = FunctionService();
      final ret = await functionService.searchQuestions(input: '季節');
      print(ret.length);
      print(ret.first.quest);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 180,
      child: Column(
        children: [
          question.authId == myData.userId
              ? Card(
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () => _deleteQuestion(context),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: const Text(
                        '投稿を削除する',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              : Card(
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () => _reportQuestion(context),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: const Text(
                        '投稿を報告する',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
          Card(
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: () => _test(context),
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: const Text(
                  'テスト機能',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
