import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/user_data.dart';
import 'package:which/utils/screen_base.dart';

class LicenseScreen extends ScreenBase {
  const LicenseScreen({super.key});

  @override
  String get title => 'ライセンス情報';
  static const String absolutePath = '/licence';
  static const String relativePath = 'licence';

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
  Widget userBuild(BuildContext context, WidgetRef ref, UserData myData) {
    final future = useMemoized(
      () => showFutureLoading<List<String>>(
        context,
        _getPackages(),
        errorValue: [],
        errorMsg: 'ライセンス情報の取得に失敗しました。',
      ),
    );
    final AsyncSnapshot<List<String>> asyncSnapshot = useFuture(future);

    final List<String> packages = asyncSnapshot.data ?? [];
    return listTemp(
      itemCount: packages.length,
      itemBuilder: (BoxConstraints constraints, int index) {
        final String package = packages[index];
        return ListTile(
          title: Text(package),
          onTap: () => context.push(LicenceDetailScreen.absolutePath(package)),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
        );
      },
    );
  }
}

class LicenceDetailScreen extends ScreenBase {
  const LicenceDetailScreen({super.key, required this.package});
  final String package;

  @override
  String get title => package;
  static String absolutePath(String package) => '/licence/$package';
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
  Widget userBuild(BuildContext context, WidgetRef ref, UserData myData) {
    final future = useMemoized(
      () => showFutureLoading<List<List<LicenseParagraph>>>(
        context,
        _getParagraphs(),
        errorValue: [],
        errorMsg: 'ライセンス情報の取得に失敗しました.',
      ),
    );
    final AsyncSnapshot<List<List<LicenseParagraph>>> asyncSnapshot =
        useFuture(future);

    if (asyncSnapshot.hasData && asyncSnapshot.data!.isEmpty) {
      return dispTemp(msg: 'ライセンス情報はありません。');
    }

    final List<List<LicenseParagraph>> paragraphs = asyncSnapshot.data ?? [];
    return textTemp(
      builder: (BoxConstraints constraints) {
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
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
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
