import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/color_set.dart';
import 'package:which/models/question.dart';
import 'package:which/models/user_data.dart';
import 'package:which/utils/wave_clipper.dart';

class CenterWidget extends HookConsumerWidget {
  const CenterWidget({
    super.key,
    required this.myData,
    required this.question,
    required this.colorSet,
    required this.pageController,
  });
  final UserData myData;
  final Question question;
  final ColorSet colorSet;
  final PageController pageController;

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
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: AutoSizeText(
                            question.answer1,
                            minFontSize: 10,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
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
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: AutoSizeText(
                            question.answer2,
                            minFontSize: 10,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
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
