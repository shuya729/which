import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/color_set.dart';
import 'package:which/utils/wave_clipper.dart';

class WhichAdWidget extends HookConsumerWidget {
  const WhichAdWidget({super.key, required this.asyncMsg});
  final ValueNotifier<String> asyncMsg;

  Future<NativeAd> _createNativeAd(ValueNotifier<bool> loaded) async {
    final String unitId = Platform.isAndroid
        ? 'ca-app-pub-9057495563597980/3551288300'
        : 'ca-app-pub-9057495563597980/4225945844';
    final NativeAd ad = NativeAd(
      adUnitId: unitId,
      factoryId: 'whichAdFactory',
      request: const AdRequest(),
      customOptions: {},
      nativeAdOptions: NativeAdOptions(
        adChoicesPlacement: AdChoicesPlacement.bottomRightCorner,
      ),
      listener: NativeAdListener(
        onAdLoaded: (_) => loaded.value = true,
        onAdFailedToLoad: (_, __) => loaded.value = false,
      ),
    );
    try {
      await ad.load();
    } catch (_) {
      asyncMsg.value = 'エラーが発生しました';
    }
    return ad;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorSet colorSet = useState(ColorSet.set()).value;
    final ValueNotifier<bool> loaded = useState(false);
    final Future<NativeAd> future = useMemoized(() => _createNativeAd(loaded));
    final AsyncSnapshot<NativeAd> whichAd = useFuture(future);
    useEffect(() => () => whichAd.data?.dispose(), [whichAd]);

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
                  const Spacer(flex: 25),
                  Container(
                    height: constraints.maxHeight * 0.22,
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: constraints.maxWidth * 0.7,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        constraints: const BoxConstraints(maxWidth: 600),
                      ),
                    ),
                  ),
                  const Spacer(flex: 51),
                ],
              );
            },
          ),
        ),
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  const Spacer(flex: 8),
                  Expanded(
                    flex: 80,
                    child: (loaded.value && whichAd.data != null)
                        ? AdWidget(ad: whichAd.data!)
                        : const SizedBox.shrink(),
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
