import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/current_config.dart';
import 'package:which/models/remote_config.dart';
import 'package:which/models/indexes.dart';
import 'package:which/models/question.dart';
import 'package:which/models/user_data.dart';
import 'package:which/providers/config_provider.dart';
import 'package:which/providers/user_stream_provider.dart';
import 'package:which/utils/screen_base.dart';
import 'package:which/views/create_screen.dart';
import 'package:which/widgets/loading_widget.dart';
import 'package:which/widgets/terms_dialog.dart';
import 'package:which/widgets/which_ad_widget.dart';
import 'package:which/widgets/which_widget.dart';

abstract class UserScreenBase extends ScreenBase {
  const UserScreenBase({super.key});

  @protected
  bool? get allowAnonymous => null;

  void _showTermsDialog(
    BuildContext context,
    RemoteConfig remoteConfig,
    CurrentConfig currentConfig,
  ) {
    final bool needCheckTerm =
        remoteConfig.needCheckTerm(currentConfig.termPath);
    final bool needCheckPrivacy =
        remoteConfig.needCheckPrivacy(currentConfig.privacyPath);
    if (needCheckTerm || needCheckPrivacy) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => TermsDialog(
            remoteConfig: remoteConfig,
            currentConfig: currentConfig,
          ),
        );
      });
    }
  }

  @protected
  Widget userBuild(
    BuildContext context,
    WidgetRef ref,
    UserData myData,
    ValueNotifier<bool> loading,
    ValueNotifier<String> asyncPath,
    ValueNotifier<String> asyncMsg,
  );

  @override
  Widget baseBuild(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> loading,
    ValueNotifier<String> asyncPath,
    ValueNotifier<String> asyncMsg,
  ) {
    final AsyncValue<RemoteConfig> asyncRemote =
        ref.watch(remoteConfigProvider);
    final AsyncValue<CurrentConfig> asyncCurrent =
        ref.watch(currentConfigProvider);
    if (asyncRemote.hasError || asyncCurrent.hasError) {
      return dispTemp(context: context, msg: '設定の取得に失敗しました。');
    } else if (asyncRemote.value == null || asyncCurrent.value == null) {
      return loadingTemp();
    } else {
      final RemoteConfig remoteConfig = asyncRemote.value!;
      final CurrentConfig currentConfig = asyncCurrent.value!;
      if (remoteConfig.mantainance) {
        return dispTemp(context: context, msg: '現在メンテナンス中です。');
      } else if (remoteConfig.needUpdate(currentConfig.version)) {
        return dispTemp(context: context, msg: 'アプリを更新してください。');
      } else {
        final AsyncValue<UserData> myData = ref.watch(userStreamProvider);
        if (myData.hasError) {
          return dispTemp(context: context, msg: '認証時にエラーが発生しました。');
        } else if (myData.value == null) {
          return loadingTemp();
        } else if (allowAnonymous == true && !myData.value!.anonymousFlg) {
          return dispTemp(context: context, msg: '不正な画面遷移です。');
        } else if (allowAnonymous == false && myData.value!.anonymousFlg) {
          return dispTemp(context: context, msg: 'ログインが必要です。');
        } else {
          useEffect(() {
            _showTermsDialog(context, remoteConfig, currentConfig);
            return null;
          }, []);
          return userBuild(
              context, ref, myData.value!, loading, asyncPath, asyncMsg);
        }
      }
    }
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
              } else if (indexes.showAd(index)) {
                return WhichAdWidget(asyncMsg: asyncMsg);
              } else {
                final int pageIndex = indexes.pageIndex(index);
                final Question? question = questions[pageIndex];
                if (question == null) return _nullWidget(refreshFunction, diff);
                return WhichWidget(
                  myData: myData,
                  question: question,
                  asyncMsg: asyncMsg,
                );
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
                            label: const Text(
                              '作成',
                              style: TextStyle(fontFamily: "NotoSansJP"),
                            ),
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
              color: Colors.white.withOpacity((diff * 4).clamp(0, 0.6)),
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
