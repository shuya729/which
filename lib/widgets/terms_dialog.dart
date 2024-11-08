import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/current_config.dart';
import 'package:which/models/remote_config.dart';
import 'package:which/providers/config_provider.dart';
import 'package:which/services/current_config_service.dart';
import 'package:which/views/privacy_screen.dart';
import 'package:which/views/term_screen.dart';

class TermsDialog extends HookConsumerWidget {
  const TermsDialog({
    super.key,
    required this.remoteConfig,
    required this.currentConfig,
  });

  final RemoteConfig remoteConfig;
  final CurrentConfig currentConfig;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<String> termPath = useState(currentConfig.termPath);
    final ValueNotifier<String> privacyPath =
        useState(currentConfig.privacyPath);

    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text(
        'ご利用前に',
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: "NotoSansJP"),
      ),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (remoteConfig.needCheckTerm(currentConfig.termPath))
            CheckboxListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: const EdgeInsets.all(0),
              controlAffinity: ListTileControlAffinity.leading,
              value: !remoteConfig.needCheckTerm(termPath.value),
              onChanged: (value) {
                final bool val = value ?? false;
                termPath.value = val ? remoteConfig.termPath : '';
              },
              title: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: "NotoSansJP",
                  ),
                  children: [
                    TextSpan(
                      text: '利用規約',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.push(TermScreen.absolutePath),
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' に同意する'),
                  ],
                ),
              ),
            ),
          if (remoteConfig.needCheckPrivacy(currentConfig.privacyPath))
            CheckboxListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: const EdgeInsets.all(0),
              controlAffinity: ListTileControlAffinity.leading,
              value: !remoteConfig.needCheckPrivacy(privacyPath.value),
              onChanged: (value) {
                final bool val = value ?? false;
                privacyPath.value = val ? remoteConfig.privacyPath : '';
              },
              title: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: "NotoSansJP",
                  ),
                  children: [
                    TextSpan(
                      text: 'プライバシーポリシー',
                      recognizer: TapGestureRecognizer()
                        ..onTap =
                            () => context.push(PrivacyScreen.absolutePath),
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' に同意する'),
                  ],
                ),
              ),
            ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: (remoteConfig.needCheckTerm(termPath.value) ||
                  remoteConfig.needCheckPrivacy(privacyPath.value))
              ? null
              : () async {
                  Navigator.of(context).pop();
                  final CurrentConfigService currentConfigService =
                      CurrentConfigService();
                  await currentConfigService.setTerms(
                    termPath: termPath.value,
                    privacyPath: privacyPath.value,
                  );
                  ref.invalidate(currentConfigProvider);
                },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('同意して続ける'),
        ),
      ],
    );
  }
}
