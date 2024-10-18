import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/color_set.dart';
import 'package:which/models/question.dart';
import 'package:which/models/user_data.dart';

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
                        isLeft ? question.answer2 : question.answer1,
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
