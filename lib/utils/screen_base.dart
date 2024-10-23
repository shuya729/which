import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/indexes.dart';
import 'package:which/models/question.dart';
import 'package:which/models/user_data.dart';
import 'package:which/providers/user_stream_provider.dart';
import 'package:which/views/create_screen.dart';
import 'package:which/widgets/loading_widget.dart';
import 'package:which/widgets/which_widget.dart';

abstract class ScreenBase extends HookConsumerWidget {
  const ScreenBase({super.key});

  @protected
  String get title;
  @protected
  bool? get allowAnonymous => null;
  @protected
  bool get initLoading => false;

  @protected
  Widget userBuild(
    BuildContext context,
    WidgetRef ref,
    UserData myData,
    ValueNotifier<bool> loading,
    ValueNotifier<String> asyncPath,
    ValueNotifier<String> asyncMsg,
  );

  Future<T?> showFutureLoading<T>(
    ValueNotifier<bool> loading,
    ValueNotifier<String> asyncMsg,
    Future<T> future, {
    String message = 'エラーが発生しました。',
  }) async {
    try {
      if (!loading.value) loading.value = true;
      final T? ret = await future;
      loading.value = false;
      return ret;
    } catch (e) {
      loading.value = false;
      asyncMsg.value = message;
      return null;
    }
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<bool> loading = useState(initLoading);
    final ValueNotifier<String> asyncPath = useState('');
    useEffect(() {
      if (asyncPath.value.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go(asyncPath.value);
        });
      }
      return null;
    }, [asyncPath.value]);
    final ValueNotifier<String> asyncMsg = useState('');
    useEffect(() {
      if (asyncMsg.value.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showMsgBar(context, asyncMsg.value);
        });
      }
      return null;
    }, [asyncMsg.value]);

    final AsyncValue<UserData> myData = ref.watch(userStreamProvider);
    return myData.when<Widget>(
      data: (UserData data) {
        if (allowAnonymous == true && !data.anonymousFlg) {
          return dispTemp(
            msg: '不正な画面遷移です。',
          );
        } else if (allowAnonymous == false && data.anonymousFlg) {
          return dispTemp(msg: 'ログインが必要です。');
        } else {
          return userBuild(
            context,
            ref,
            data,
            loading,
            asyncPath,
            asyncMsg,
          );
        }
      },
      loading: () => loadingTemp(),
      error: (_, __) => dispTemp(msg: '認証時にエラーが発生しました。'),
    );
  }

  Widget textTemp({
    required bool loading,
    required Widget Function(BuildContext context, BoxConstraints constraints)
        builder,
  }) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: title.isEmpty
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(45),
              child: AppBar(
                iconTheme: const IconThemeData(size: 18),
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
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
                        child: builder(context, constraints),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          loading
              ? ModalBarrier(
                  dismissible: false,
                  color: Colors.white60,
                )
              : const SizedBox(),
          AnimatedOpacity(
            opacity: loading ? 1 : 0,
            duration: const Duration(milliseconds: 100),
            child: const LoadingWidget(),
          ),
        ],
      ),
    );
  }

  Widget listTemp({
    required bool loading,
    required int itemCount,
    required Widget Function(
            BuildContext context, BoxConstraints constraints, int index)
        itemBuilder,
    ScrollController? scrollController,
  }) {
    return Scaffold(
      appBar: title.isEmpty
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(45),
              child: AppBar(
                iconTheme: const IconThemeData(size: 18),
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
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
                          return itemBuilder(context, constraints, index);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          loading
              ? ModalBarrier(
                  dismissible: false,
                  color: Colors.white60,
                )
              : const SizedBox(),
          AnimatedOpacity(
            opacity: loading ? 1 : 0,
            duration: const Duration(milliseconds: 100),
            child: const LoadingWidget(),
          ),
        ],
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
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
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
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
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

  Widget _nullWidget(void Function() refresh, double diff) {
    return SafeArea(
      child: Center(
        child: IconButton(
          onPressed: refresh,
          icon: AnimatedOpacity(
            opacity: diff == 0 ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            child: const Icon(
              Icons.refresh,
              size: 40,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget questionsTemp({
    required bool loading,
    required ValueNotifier<String> asyncMsg,
    required UserData myData,
    int? itemCount,
    required PageController pageController,
    required List<Question?> questions,
    required Indexes indexes,
    required double diff,
    required void Function(int) onPageChanged,
    required void Function() refreshFunction,
    required void Function() reloadFunciton,
    required Widget Function(BuildContext context, BoxConstraints constraints)
        topBuilder,
    Widget? drawer,
    Widget? endDrawer,
  }) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: pageController,
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: itemCount,
            onPageChanged: (value) {
              if (indexes.hasPage(value)) onPageChanged(value);
            },
            itemBuilder: (context, index) {
              if (!indexes.hasPage(index)) {
                return _nullWidget(refreshFunction, diff);
              }
              final int pageIndex = indexes.pageIndex(index);
              final Question? question = questions[pageIndex];
              if (question == null) return _nullWidget(refreshFunction, diff);
              return WhichWidget(
                myData: myData,
                question: question,
                asyncMsg: asyncMsg,
              );
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
                      child: topBuilder(context, constraints),
                    ),
                    const Spacer(flex: 80),
                    Container(
                      height: constraints.maxHeight * 0.12,
                      constraints: const BoxConstraints(minHeight: 65),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (indexes.current == indexes.top) {
                                refreshFunction();
                              } else {
                                pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            icon: indexes.current == indexes.top
                                ? const Icon(Icons.refresh)
                                : const Icon(Icons.keyboard_arrow_up),
                            style: IconButton.styleFrom(
                              foregroundColor: Colors.white70,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.push(CreateScreen.absolutePath);
                            },
                            label: const Text('作成'),
                            icon: const Icon(Icons.add),
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black87,
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
                          IconButton(
                            onPressed: () {
                              if (indexes.current == indexes.bottom) {
                                reloadFunciton();
                              } else {
                                pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            icon: indexes.current == indexes.bottom
                                ? const Icon(Icons.refresh)
                                : const Icon(Icons.keyboard_arrow_down),
                            style: IconButton.styleFrom(
                              foregroundColor: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: Container(
              color: Colors.white.withOpacity((diff * 4).clamp(0, 0.4)),
            ),
          ),
          loading
              ? ModalBarrier(
                  dismissible: false,
                  color: Colors.white60,
                )
              : const SizedBox(),
          AnimatedOpacity(
            opacity: loading ? 1 : 0,
            duration: const Duration(milliseconds: 100),
            child: const LoadingWidget(),
          ),
        ],
      ),
      drawer: drawer,
      endDrawer: endDrawer,
    );
  }
}
