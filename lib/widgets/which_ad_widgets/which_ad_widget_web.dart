// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/color_set.dart';
import 'package:which/utils/wave_clipper.dart';

class WhichAdWidget extends HookConsumerWidget {
  const WhichAdWidget({super.key});

  List<Widget> _appStoreChildren(BoxConstraints constraints) {
    return [
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            html.window.open(
              'https://apps.apple.com/jp/app/bipick/id6737619772',
              'App Store',
            );
          },
          child: Container(
            width: constraints.maxWidth * 0.18,
            constraints: BoxConstraints(
              minWidth: 120,
              maxWidth: 160,
            ),
            child: Image.asset(
              'assets/system/app_store.png',
            ),
          ),
        ),
      ),
      const SizedBox(height: 5, width: 15),
      Text(
        'for iOS',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    ];
  }

  List<Widget> _googlePlayChildren(BoxConstraints constraints) {
    return [
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            html.window.open(
              'https://play.google.com/store/apps/details?id=com.which464.which',
              'Google Play',
            );
          },
          child: Container(
            width: constraints.maxWidth * 0.18,
            constraints: BoxConstraints(
              minWidth: 120,
              maxWidth: 160,
            ),
            child: Image.asset(
              'assets/system/google_play.png',
            ),
          ),
        ),
      ),
      const SizedBox(height: 5, width: 15),
      Text(
        'for Android',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorSet colorSet = useState(ColorSet.set()).value;

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
                  const Spacer(flex: 25),
                  Container(
                    height: constraints.maxHeight * 0.22,
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: constraints.maxWidth * 0.7,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        constraints: const BoxConstraints(maxWidth: 600),
                      ),
                    ),
                  ),
                  const Spacer(flex: 51),
                ],
              );
            },
          ),
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
                        child: Text(
                          'BiPick のアプリをダウンロード',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight * 0.22,
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: constraints.maxWidth * 0.7,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: constraints.maxWidth * 0.7 > 380
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _appStoreChildren(constraints),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _appStoreChildren(constraints),
                              ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 6),
                  Container(
                    height: constraints.maxHeight * 0.22,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: constraints.maxWidth * 0.7,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: constraints.maxWidth * 0.7 > 380
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _googlePlayChildren(constraints),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _googlePlayChildren(constraints),
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
