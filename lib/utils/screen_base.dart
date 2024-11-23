import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/views/home_screen.dart';
import 'package:which/widgets/loading_widget.dart';

abstract class ScreenBase extends HookConsumerWidget {
  const ScreenBase({super.key});

  String get title;
  bool get initLoading => false;

  @protected
  Widget baseBuild(
    BuildContext context,
    WidgetRef ref,
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

    return baseBuild(context, ref, loading, asyncPath, asyncMsg);
  }

  Widget textTemp({
    required BuildContext context,
    required bool loading,
    required Widget Function(BuildContext context, BoxConstraints constraints)
        builder,
  }) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
          leading: context.canPop()
              ? BackButton(style: IconButton.styleFrom(iconSize: 18))
              : IconButton(
                  onPressed: () => context.go(HomeScreen.absolutePath),
                  icon: Image.asset(
                    'assets/system/bipick_logo.png',
                    width: 28,
                    height: 28,
                  ),
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
    required BuildContext context,
    required bool loading,
    required int itemCount,
    required Widget Function(
            BuildContext context, BoxConstraints constraints, int index)
        itemBuilder,
    ScrollController? scrollController,
  }) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
          leading: context.canPop()
              ? BackButton(style: IconButton.styleFrom(iconSize: 18))
              : IconButton(
                  onPressed: () => context.go(HomeScreen.absolutePath),
                  icon: Image.asset(
                    'assets/system/bipick_logo.png',
                    width: 28,
                    height: 28,
                  ),
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
      body: const SafeArea(
        child: LoadingWidget(),
      ),
    );
  }

  Widget dispTemp({required BuildContext context, required String msg}) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
          leading: context.canPop()
              ? BackButton(style: IconButton.styleFrom(iconSize: 18))
              : IconButton(
                  onPressed: () => context.go(HomeScreen.absolutePath),
                  icon: Image.asset(
                    'assets/system/bipick_logo.png',
                    width: 28,
                    height: 28,
                  ),
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
}
