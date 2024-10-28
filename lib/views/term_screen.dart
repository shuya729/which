import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/remote_config.dart';
import 'package:which/models/terms.dart';
import 'package:which/providers/config_provider.dart';
import 'package:which/services/storage_service.dart';
import 'package:which/utils/screen_base.dart';

class TermScreen extends ScreenBase {
  const TermScreen({super.key});

  @override
  String get title => '利用規約';
  static const String absolutePath = '/term';
  static const String relativePath = 'term';
  @override
  bool get initLoading => true;

  Future<List<Terms?>> getTerms(RemoteConfig remoteConfig) async {
    final StorageService storageService = StorageService();
    final String termPath = remoteConfig.termPath;
    return await storageService.getTerm(termPath);
  }

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
    if (asyncRemote.hasError) {
      return dispTemp(msg: '設定の取得に失敗しました。');
    } else if (asyncRemote.value == null) {
      return loadingTemp();
    } else {
      final RemoteConfig remoteConfig = asyncRemote.value!;
      return _baseBuild(
        context,
        ref,
        loading,
        asyncPath,
        asyncMsg,
        remoteConfig,
      );
    }
  }

  Widget _baseBuild(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> loading,
    ValueNotifier<String> asyncPath,
    ValueNotifier<String> asyncMsg,
    RemoteConfig remoteConfig,
  ) {
    final future = useMemoized(
      () => showFutureLoading(loading, asyncMsg, getTerms(remoteConfig)),
    );
    final AsyncSnapshot<List<Terms?>?> asyncSnapshot = useFuture(future);

    final List<Terms?> terms = asyncSnapshot.data ?? [];
    return textTemp(
      loading: loading.value,
      builder: (BuildContext context, BoxConstraints constraints) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: terms.length,
          itemBuilder: (context, index) {
            final Terms? term = terms[index];
            if (term == null) return null;
            return Padding(
              padding: EdgeInsets.only(
                top: term.type == 'content' ? 5 : 30,
                bottom: term.type == 'content' ? 5 : 10,
                left: 10 * term.indent.toDouble(),
              ),
              child: Text(
                term.text,
                textAlign: (term.type == 'signature')
                    ? TextAlign.right
                    : (term.type == 'title')
                        ? TextAlign.center
                        : TextAlign.left,
                style: TextStyle(
                  fontSize: term.type == 'title' ? 20 : 14,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
