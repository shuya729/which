import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/utils/screen_base.dart';

class LicenseScreen extends ScreenBase {
  const LicenseScreen({super.key});

  @override
  String get title => 'ライセンス情報';
  static const String absolutePath = '/license';
  static const String relativePath = 'license';
  @override
  bool get initLoading => true;

  Future<List<String>> _getPackages() async {
    final Stream stream = LicenseRegistry.licenses;
    final List<String> packages = [];
    await for (final LicenseEntry license in stream) {
      if (!packages.contains(license.packages.toList().first)) {
        packages.add(license.packages.toList().first);
      }
    }
    return packages;
  }

  @override
  Widget baseBuild(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> loading,
    ValueNotifier<String> asyncPath,
    ValueNotifier<String> asyncMsg,
  ) {
    final future = useMemoized(
      () => showFutureLoading(loading, asyncMsg, _getPackages()),
    );
    final AsyncSnapshot<List<String>?> asyncSnapshot = useFuture(future);

    final List<String> packages = asyncSnapshot.data ?? [];
    return listTemp(
      context: context,
      loading: loading.value,
      itemCount: packages.length,
      itemBuilder:
          (BuildContext context, BoxConstraints constraints, int index) {
        final String package = packages[index];
        return ListTile(
          title: Text(package),
          onTap: () => context.push(LicenseDetailScreen.absolutePath(package)),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
        );
      },
    );
  }
}

class LicenseDetailScreen extends ScreenBase {
  const LicenseDetailScreen({super.key, required this.package});
  final String package;

  @override
  String get title => package;
  static String absolutePath(String package) => '/license/$package';
  static const String relativePath = ':package';

  Future<List<List<LicenseParagraph>>> _getParagraphs() async {
    final Stream stream = LicenseRegistry.licenses;
    final List<List<LicenseParagraph>> paragraphs = [];
    await for (final LicenseEntry license in stream) {
      if (license.packages.toList().contains(package)) {
        paragraphs.add(license.paragraphs.toList());
      }
    }
    return paragraphs;
  }

  @override
  Widget baseBuild(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> loading,
    ValueNotifier<String> asyncPath,
    ValueNotifier<String> asyncMsg,
  ) {
    final future = useMemoized(
      () => showFutureLoading(loading, asyncMsg, _getParagraphs()),
    );
    final AsyncSnapshot<List<List<LicenseParagraph>>?> asyncSnapshot =
        useFuture(future);

    if (asyncSnapshot.hasData && asyncSnapshot.data!.isEmpty) {
      return dispTemp(context: context, msg: 'ライセンス情報はありません。');
    }

    final List<List<LicenseParagraph>> paragraphs = asyncSnapshot.data ?? [];
    return textTemp(
      context: context,
      loading: loading.value,
      builder: (BuildContext context, BoxConstraints constraints) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const Divider(height: 60),
          itemCount: paragraphs.length,
          itemBuilder: (context, index) {
            final List<LicenseParagraph> paragraph = paragraphs[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: paragraph.map(
                (LicenseParagraph p) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      left: 10 * p.indent.toDouble(),
                    ),
                    child: Text(
                      p.text,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                },
              ).toList(),
            );
          },
        );
      },
    );
  }
}
