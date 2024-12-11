import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/color_set.dart';
import 'package:which/providers/which_ad_provider.dart';
import 'package:which/utils/wave_clipper.dart';

class WhichAdWidget extends HookConsumerWidget {
  const WhichAdWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorSet colorSet = useState(ColorSet.set()).value;
    final WhichAdNotifier whichAdNotifier = ref.read(whichAdProvider.notifier);
    final Future<NativeAd?> futureAd =
        useMemoized(() => whichAdNotifier.load());
    final AsyncSnapshot<NativeAd?> whichAd =
        useFuture(futureAd, initialData: null);
    useEffect(() => whichAd.data?.dispose, const []);

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
          child: Column(
            children: [
              const Spacer(flex: 8),
              Expanded(
                flex: 80,
                child: whichAd.hasData
                    ? AdWidget(ad: whichAd.data!)
                    : const SizedBox.shrink(),
              ),
              const Spacer(flex: 12),
            ],
          ),
        ),
      ],
    );
  }
}
