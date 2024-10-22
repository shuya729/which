import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:which/models/color_set.dart';
import 'package:which/models/question.dart';
import 'package:which/models/question_id.dart';
import 'package:which/models/user_data.dart';
import 'package:which/models/vote.dart';
import 'package:which/services/firestore_service.dart';
import 'package:which/widgets/bottom_sheet_widget.dart';
import 'package:which/widgets/center_widget.dart';
import 'package:which/widgets/side_widget.dart';

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

  Future<void> _init() async {
    final FirestoreService firestoreService = FirestoreService();
    final QuestionId? readed =
        await firestoreService.getReaded(myData, question);
    await firestoreService.setReaded(myData, question);
    if (readed != null) return;
    await firestoreService.updateQuestion(question, incrementRead: true);
  }

  Future<void> _onPageChanged(
    int value,
    ValueNotifier<int> vote,
  ) async {
    final FirestoreService firestoreService = FirestoreService();
    final QuestionId? watched =
        await firestoreService.getWatched(myData, question);
    await firestoreService.setWatched(myData, question);
    if (watched != null) return;
    await firestoreService.updateQuestion(question, incrementWatch: true);

    if (vote.value != 0 || value == 1) return;
    if (value == 0) vote.value = 2;
    if (value == 2) vote.value = 1;
    final Vote? voted = await firestoreService.getVoted(myData, question);
    if (voted != null) return;
    await _addVote(vote.value);
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

  Future<void> _saveQuestion(bool asyncSaved) async {
    final FirestoreService firestoreService = FirestoreService();
    if (myData.anonymousFlg) {
      asyncMsg.value = 'ログインが必要です。';
      return;
    } else if (asyncSaved) {
      await firestoreService.deleteSaved(myData, question).catchError(
        (_) {
          asyncMsg.value = '保存解除に失敗しました。';
        },
      );
    } else {
      await firestoreService.setSaved(myData, question).catchError(
        (_) {
          asyncMsg.value = '保存に失敗しました。';
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

  Future<void> _addVote(int vote) async {
    final FirestoreService firestoreService = FirestoreService();
    await firestoreService.setVoted(myData, question, vote).catchError(
      (_) {
        asyncMsg.value = '回答に失敗しました。';
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
      backgroundColor: Colors.grey.shade100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return BottomSheetWidget(
          myData: myData,
          question: question,
          asyncMsg: asyncMsg,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorSet colorSet = useState(ColorSet.set()).value;
    final PageController pageController = usePageController(initialPage: 1);
    final Stream<Question> streamQuestion =
        useMemoized(() => _getQuestionStream(), [question]);
    final Question asyncQuestion = useStream(streamQuestion).data ?? question;
    final Future<UserData?> futureUser =
        useMemoized(() => _getUser(), [question]);
    final UserData? asyncUser = useFuture(futureUser).data;
    final Stream<bool> streamSaved =
        useMemoized(() => _getSavedStream(), [myData, question]);
    final bool asyncSaved = useStream(streamSaved).data ?? false;
    final ValueNotifier<int> vote = useState(0);
    final Stream<bool> streamVoted =
        useMemoized(() => _getVotedStream(), [myData, question]);
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
          onPageChanged: (value) => _onPageChanged(value, vote),
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
                                  onPressed: null,
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
                              !asyncVoted
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
                                    onPressed: () => _saveQuestion(asyncSaved),
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
                                      backgroundColor: Colors.white24,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _showBottomSheet(context),
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
