import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/color_set.dart';
import 'package:which/utils/wave_clipper.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return const WhichWidget();
            },
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: constraints.maxHeight * 0.08,
                      constraints: const BoxConstraints(minHeight: 45),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SizedBox(
                        width: double.infinity,
                        height: max(40, constraints.maxHeight * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer(),
                              style: IconButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Flexible(
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
                                child: TextField(
                                  onSubmitted: (value) {},
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
                                    suffixIconColor:
                                        Colors.white.withOpacity(0.8),
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
                            const SizedBox(width: 15),
                            IconButton(
                              onPressed: () =>
                                  Scaffold.of(context).openEndDrawer(),
                              icon: const CircleAvatar(
                                radius: 16.5,
                                backgroundColor: Colors.white,
                                foregroundImage: NetworkImage(
                                  'https://picsum.photos/200/300',
                                ),
                              ),
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(flex: 80),
                    Container(
                      height: constraints.maxHeight * 0.12,
                      constraints: const BoxConstraints(minHeight: 65),
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        onPressed: () {},
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
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      endDrawer: const EndDrawerWidget(),
    );
  }
}

class WhichWidget extends HookConsumerWidget {
  const WhichWidget({super.key});

  void _onPageChanged(int value, ValueNotifier<int> answer) {
    if (answer.value == 1 && value != 1) answer.value = value;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorSet colorSet = useState(ColorSet.set()).value;
    final PageController pageController = usePageController(initialPage: 1);
    final ValueNotifier<int> answer = useState(1);
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView(
          scrollDirection: Axis.horizontal,
          controller: pageController,
          onPageChanged: (value) => _onPageChanged(value, answer),
          children: [
            SideWidget(
              isLeft: true,
              colorSet: colorSet,
              pageController: pageController,
              answer: answer.value,
            ),
            CenterWidget(
              colorSet: colorSet,
              pageController: pageController,
            ),
            SideWidget(
              isLeft: false,
              colorSet: colorSet,
              pageController: pageController,
              answer: answer.value,
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
                        child: const AutoSizeText(
                          'Question',
                          // '制御が効かないトロッコ。進む先には、5人の作業員がいます。進行方向を変えるレバーの前に立つあなた。レバーを引けば線路が切り替わり5人を救えますが、今度は切り替えた先にいる1人の作業員が犠牲になってしまいます。\n\nあなたは、1人と5人、どちらの命を選びますか？',
                          textAlign: TextAlign.center,
                          minFontSize: 10,
                          style: TextStyle(
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
                        TextButton.icon(
                          onPressed: () {},
                          icon: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.black.withOpacity(0.6),
                            child: const CircleAvatar(
                              radius: 18.4,
                              backgroundColor: Colors.white,
                              foregroundImage: NetworkImage(
                                'https://picsum.photos/200/300',
                              ),
                            ),
                          ),
                          label: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'User Name',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'yyyy/mm/dd',
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
                            backgroundColor: Colors.white.withOpacity(0.2),
                            foregroundColor: Colors.white,
                            fixedSize: Size(constraints.maxWidth * 0.45, 54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.bookmark),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                foregroundColor: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.ios_share),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                foregroundColor: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
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
    required this.colorSet,
    required this.pageController,
  });
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
                          constraints: const BoxConstraints(maxWidth: 780),
                          child: const AutoSizeText(
                            'RIGHT',
                            // '制御が効かないトロッコ。進む先には、5人の作業員がいます。進行方向を変えるレバーの前に立つあなた。レバーを引けば線路が切り替わり5人を救えますが、今度は切り替えた先にいる1人の作業員が犠牲になってしまいます。\n\nあなたは、1人と5人、どちらの命を選びますか？',
                            minFontSize: 10,
                            style: TextStyle(
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
                          child: const AutoSizeText(
                            'LEFT',
                            // '制御が効かないトロッコ。進む先には、5人の作業員がいます。進行方向を変えるレバーの前に立つあなた。レバーを引けば線路が切り替わり5人を救えますが、今度は切り替えた先にいる1人の作業員が犠牲になってしまいます。\n\nあなたは、1人と5人、どちらの命を選びますか？',
                            minFontSize: 10,
                            style: TextStyle(
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
    required this.isLeft,
    required this.colorSet,
    required this.pageController,
    required this.answer,
  });
  final bool isLeft;
  final ColorSet colorSet;
  final PageController pageController;
  final int answer;

  void _onEnd(ValueNotifier<int> count, ValueNotifier<int> total) {
    count.value++;
    total.value++;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color backColor = isLeft ? colorSet.leftColor : colorSet.rightColor;
    final ValueNotifier<int> count = useState(595);
    final ValueNotifier<int> total = useState(2304);
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
                        isLeft ? 'LEFT' : 'RIGHT',
                        // '制御が効かないトロッコ。進む先には、5人の作業員がいます。進行方向を変えるレバーの前に立つあなた。レバーを引けば線路が切り替わり5人を救えますが、今度は切り替えた先にいる1人の作業員が犠牲になってしまいます。\n\nあなたは、1人と5人、どちらの命を選びますか？',
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
                    opacity: answer != 1 ? 1 : 0,
                    duration: const Duration(milliseconds: 600),
                    onEnd: () => _onEnd(count, total),
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
                                count == total
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
  const DrawerWidget({super.key});
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
            onTap: () => GoRouter.of(context).push('/term'),
          ),
          ListTile(
            title: const Text('プライバシーポリシー'),
            onTap: () => GoRouter.of(context).push('/privacy'),
          ),
          ListTile(
            title: const Text('ライセンス情報'),
            onTap: () => GoRouter.of(context).push('/licence'),
          ),
          ListTile(
            title: const Text('お問い合わせ'),
            onTap: () => GoRouter.of(context).push('/contact'),
          ),
        ],
      ),
    );
  }
}

class EndDrawerWidget extends HookConsumerWidget {
  const EndDrawerWidget({super.key});
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
                'アカウント',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('プロフィール'),
            onTap: () => GoRouter.of(context).push('/profile'),
          ),
          ListTile(
            title: const Text('作成済み'),
            onTap: () => GoRouter.of(context).push('/created'),
          ),
          ListTile(
            title: const Text('保存済み'),
            onTap: () => GoRouter.of(context).push('/saved'),
          ),
          Divider(
            indent: 10,
            endIndent: 10,
            height: 20,
            thickness: 1.6,
            color: Colors.black.withOpacity(0.6),
          ),
          ListTile(
            title: const Text('サインイン'),
            onTap: () => GoRouter.of(context).push('/signin'),
          ),
          ListTile(
            title: const Text('サインアウト'),
            onTap: () => GoRouter.of(context).push('/signout'),
          ),
          ListTile(
            title: const Text('アカウント削除'),
            onTap: () => GoRouter.of(context).push('/delete'),
          ),
        ],
      ),
    );
  }
}
