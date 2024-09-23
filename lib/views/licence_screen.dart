import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/utils/screen_base.dart';

class LicenceScreen extends ScreenBase {
  const LicenceScreen({super.key});

  @override
  String get title => 'ライセンス情報';

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
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncSnapshot<List<String>> asyncPackages = useFuture(_getPackages());

    if (asyncPackages.hasData) {
      final List<String> packages = asyncPackages.data!;
      return listTemp(
        itemCount: packages.length,
        childrenBuilder: (constraints, index) {
          final String package = packages[index];
          return ListTile(
            title: Text(package),
            onTap: () => GoRouter.of(context).go('/licence/$package'),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
            ),
          );
        },
      );
    } else {
      return loadingTemp();
    }
  }
}

class LicenceDetailScreen extends ScreenBase {
  const LicenceDetailScreen({super.key, required this.package});
  final String package;

  @override
  String get title => package;

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
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncSnapshot<List<List<LicenseParagraph>>> asyncParagraphs =
        useFuture(_getParagraphs());

    if (asyncParagraphs.hasData) {
      final List<List<LicenseParagraph>> paragraphs = asyncParagraphs.data!;
      return textTemp(
        childBuilder: (constraints) {
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
                        ));
                  },
                ).toList(),
              );
            },
          );
        },
      );
    } else {
      return loadingTemp();
    }
  }
}
