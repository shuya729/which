import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'color_set.freezed.dart';

@freezed
class ColorSet with _$ColorSet {
  const factory ColorSet({
    required Color leftColor,
    required Color rightColor,
  }) = _ColorSet;

  factory ColorSet.set() {
    final int leftHue = Random().nextInt(360);
    final int rightHue = (Random().nextInt(300) + leftHue + 30) % 360;
    final double leftLRest = (50 < leftHue && leftHue < 80) ? 0.15 : 0;
    final double rightLRest = (50 < rightHue && rightHue < 80) ? 0.15 : 0;
    final double leftLightness =
        Random().nextDouble() * (0.4 - leftLRest) + 0.3;
    final double rightLightness =
        Random().nextDouble() * (0.4 - rightLRest) + 0.3;
    final double leftSRest =
        (0.45 < leftLightness && leftLightness < 0.55) ? 0.15 : 0;
    final double rightSRest =
        (0.45 < rightLightness && rightLightness < 0.55) ? 0.15 : 0;
    final double leftSaturation =
        Random().nextDouble() * (0.5 - leftSRest) + 0.4;
    final double rightSaturation =
        Random().nextDouble() * (0.5 - rightSRest) + 0.4;
    return ColorSet(
      leftColor: HSLColor.fromAHSL(
        1,
        leftHue.toDouble(),
        leftSaturation,
        leftLightness,
      ).toColor(),
      rightColor: HSLColor.fromAHSL(
        1,
        rightHue.toDouble(),
        rightSaturation,
        rightLightness,
      ).toColor(),
    );
  }
}
