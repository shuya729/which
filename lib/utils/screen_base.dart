import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/indexes.dart';
import 'package:which/models/question.dart';
import 'package:which/models/user_data.dart';
import 'package:which/providers/user_stream_provider.dart';
import 'package:which/views/home_screen.dart';
import 'package:which/widgets/loading_widget.dart';

abstract class ScreenBase extends HookConsumerWidget with ScreenBaseFunction {
  const ScreenBase({super.key});

  @protected
  String get title;
  @protected
  bool? get allowAnonymous => null;

  @protected
  Widget userBuild(BuildContext context, WidgetRef ref, UserData myData);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserData> myData = ref.watch(userStreamProvider);
    return myData.when<Widget>(
      data: (UserData data) {
        if (allowAnonymous == true && !data.anonymousFlg) {
          return dispTemp(msg: '不正な画面遷移です。');
        } else if (allowAnonymous == false && data.anonymousFlg) {
          return dispTemp(msg: 'ログインが必要です。');
        } else {
          return userBuild(context, ref, data);
        }
      },
      loading: () => loadingTemp(),
      error: (_, __) => dispTemp(msg: '認証時にエラーが発生しました。'),
    );
  }

  Widget textTemp({
    required Widget Function(BoxConstraints constraints) builder,
  }) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: title.isEmpty
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(45),
              child: AppBar(
                iconTheme: const IconThemeData(size: 18),
                title: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Center(
                child: Container(
                  width: constraints.maxWidth * 0.94,
                  constraints: const BoxConstraints(maxWidth: 800),
                  margin: EdgeInsets.symmetric(
                    vertical: constraints.maxHeight * 0.03,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: constraints.maxWidth * 0.8,
                    constraints: const BoxConstraints(maxWidth: 600),
                    margin: EdgeInsets.only(
                      top: constraints.maxHeight * 0.07,
                      bottom: constraints.maxHeight * 0.07 + 20,
                    ),
                    child: builder(constraints),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget listTemp({
    required int itemCount,
    required Widget Function(BoxConstraints constraints, int index) itemBuilder,
    ScrollController? scrollController,
  }) {
    return Scaffold(
      appBar: title.isEmpty
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(45),
              child: AppBar(
                iconTheme: const IconThemeData(size: 18),
                title: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Center(
                child: Container(
                  width: constraints.maxWidth * 0.94,
                  constraints: const BoxConstraints(maxWidth: 800),
                  margin: EdgeInsets.symmetric(
                    vertical: constraints.maxHeight * 0.03,
                  ),
                  alignment: Alignment.center,
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 40),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      return itemBuilder(constraints, index);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget loadingTemp() {
    return Scaffold(
      appBar: title.isEmpty
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(45),
              child: AppBar(
                iconTheme: const IconThemeData(size: 18),
                title: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
      body: const SafeArea(
        child: LoadingWidget(),
      ),
    );
  }

  Widget dispTemp({required String msg}) {
    return Scaffold(
      appBar: title.isEmpty
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(45),
              child: AppBar(
                iconTheme: const IconThemeData(size: 18),
                title: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              msg,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }

  Widget questionsTemp({
    required PageController pageController,
    required UserData myData,
    required List<Question?> questions,
    required Indexes indexes,
    required void Function(int) onPageChanged,
    required Widget Function(BoxConstraints constraints) bottomBuilder,
    Widget Function(BoxConstraints constraints)? topBuilder,
    Widget? drawer,
    Widget? endDrawer,
  }) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      appBar: title.isEmpty
          ? null
          : AppBar(
              iconTheme: const IconThemeData(size: 18),
              title: Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final int pageIndex = index % Indexes.limit;
              final Question? question = questions[pageIndex];
              if (pageIndex == indexes.bottom || question == null) {
                return null;
                // } else if(pageIndex % 20 == 17) {
                //   // 広告
                //   return const SizedBox.shrink();
              } else {
                return WhichWidget(myData: myData, question: question);
              }
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
                      child:
                          topBuilder == null ? null : topBuilder(constraints),
                    ),
                    const Spacer(flex: 80),
                    Container(
                      height: constraints.maxHeight * 0.12,
                      constraints: const BoxConstraints(minHeight: 65),
                      alignment: Alignment.center,
                      child: bottomBuilder(constraints),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      drawer: drawer,
      endDrawer: endDrawer,
    );
  }
}

mixin class ScreenBaseFunction {
  Future<T> showFutureLoading<T>(
    BuildContext context,
    Future<T> future, {
    required T errorValue,
    String? errorMsg,
    void Function(BuildContext context)? afterDialog,
    Color? barrierColor,
  }) async {
    bool errorFlg = false;
    bool unnotifieFlg = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: barrierColor ?? Colors.white60,
          builder: (context) => const LoadingWidget(),
        );
      }
    });
    final T ret = await future.catchError((e) {
      errorFlg = true;
      unnotifieFlg = e.toString() == 'unnotified-error';
      return errorValue;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Navigator.pop(context);
        if (!unnotifieFlg) {
          if (errorFlg) {
            if (context.mounted) showMsgBar(context, errorMsg ?? 'エラーが発生しました。');
          } else {
            if (afterDialog != null && context.mounted) afterDialog(context);
          }
        }
      }
    });
    return ret;
  }

  void showMsgBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(msg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
