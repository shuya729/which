import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/link.dart';
import 'package:which/models/color_set.dart';
import 'package:which/utils/wave_clipper.dart';

class WhichStoreWidget extends HookConsumerWidget {
  const WhichStoreWidget({super.key});

  List<Widget> _appStoreChildren(BoxConstraints constraints) {
    final Uri appStoreUri =
        Uri.parse('https://apps.apple.com/jp/app/bipick/id6737619772');

    final List<Widget> list = [
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Link(
          uri: appStoreUri,
          target: LinkTarget.blank,
          builder: (context, followLink) {
            return GestureDetector(
              onTap: followLink,
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
            );
          },
        ),
      ),
    ];

    if (constraints.maxHeight * 0.22 > 70) {
      list.add(const SizedBox(height: 5, width: 15));
      list.add(
        const Text(
          'for iOS',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      );
    }

    return list;
  }

  List<Widget> _googlePlayChildren(BoxConstraints constraints) {
    final Uri googlePlayUri = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.which464.which');
    final List<Widget> list = [
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Link(
          uri: googlePlayUri,
          target: LinkTarget.blank,
          builder: (context, followLink) {
            return GestureDetector(
              onTap: followLink,
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
            );
          },
        ),
      ),
    ];

    if (constraints.maxHeight * 0.22 > 70) {
      list.add(const SizedBox(height: 5, width: 15));
      list.add(
        const Text(
          'for Android',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      );
    }

    return list;
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
                          'BiPick のアプリをダウンロード',
                          textAlign: TextAlign.center,
                          minFontSize: 10,
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
