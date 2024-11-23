import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final whichAdProvider = StateNotifierProvider<WhichAdNotifier, NativeAd?>((_) {
  return WhichAdNotifier();
});

class WhichAdNotifier extends StateNotifier<NativeAd?> {
  WhichAdNotifier() : super(null) {
    _init();
  }

  DateTime? _adDate;

  Future<void> _init() async {
    if (kIsWeb) return;
    state = await _loadAd();
  }

  Future<NativeAd?> load() async {
    if (kIsWeb) return null;
    final Duration baseDuration = const Duration(hours: 1);
    final DateTime baseDate = DateTime.now().subtract(baseDuration);
    if (_adDate != null && _adDate!.isBefore(baseDate)) {
      _adDate = null;
      state?.dispose();
      state = null;
    }

    NativeAd? ad = state;
    ad ??= await _loadAd();
    _loadAd().then((ad) => state = ad);
    return ad;
  }

  Future<NativeAd?> _loadAd() async {
    if (kIsWeb) return null;
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
        onAdLoaded: (ad) => _adDate = DateTime.now(),
        onAdFailedToLoad: (ad, _) => _adDate = null,
      ),
    );
    try {
      await ad.load();
      return ad;
    } catch (_) {
      await ad.dispose();
      return null;
    }
  }

  @override
  void dispose() {
    state?.dispose();
    super.dispose();
  }
}
