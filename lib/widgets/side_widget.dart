import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/color_set.dart';
import 'package:which/models/counter.dart';
import 'package:which/models/question.dart';
import 'package:which/models/user_data.dart';

class SideWidget extends HookConsumerWidget {
  const SideWidget({
    super.key,
    required this.myData,
    required this.question,
    required this.counter,
    required this.isLeft,
    required this.colorSet,
    required this.pageController,
    required this.voted,
  });
  final UserData myData;
  final Question question;
  final Counter? counter;
  final bool isLeft;
  final ColorSet colorSet;
  final PageController pageController;
  final bool voted;

  String _rateStr(Question question, Counter? counter) {
    final int answer1 = counter?.answer1 ?? 0;
    final int answer2 = counter?.answer2 ?? 0;
    final int count = isLeft ? answer2 : answer1;
    final int total = answer1 + answer2;
    if (count == total) return '100';
    return (count / total * 100).toStringAsFixed(1);
  }

  String _countStr(Question question, Counter? counter) {
    final int answer1 = counter?.answer1 ?? 0;
    final int answer2 = counter?.answer2 ?? 0;
    final int count = isLeft ? answer2 : answer1;
    return '$count p';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color backColor = isLeft ? colorSet.leftColor : colorSet.rightColor;
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
                    width: constraints.maxWidth * 0.85,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: AutoSizeText(
                        isLeft ? question.answer2 : question.answer1,
                        minFontSize: 10,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
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
                      foregroundColor: Colors.white70,
                    ),
                  ),
                ),
                Container(
                  height: constraints.maxHeight * 0.22,
                  alignment: Alignment.topCenter,
                  child: AnimatedOpacity(
                    opacity: (voted && counter != null) ? 1 : 0,
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
                                _rateStr(question, counter),
                                minFontSize: 30,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 60,
                                  fontWeight: FontWeight.w500,
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
                                  color: Colors.white70,
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
                            _countStr(question, counter),
                            minFontSize: 10,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 22,
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
