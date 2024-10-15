import 'package:flutter/material.dart';

@immutable
class Indexes {
  const Indexes({
    int top = 0,
    int bottom = 0,
  })  : top = (top < 1) ? 0 : top % limit,
        bottom = (bottom < 1) ? 0 : bottom % limit;

  static const int limit = 80;
  final int top;
  final int bottom;

  // copyWith
  Indexes copyWith({
    int? top,
    int? bottom,
  }) {
    return Indexes(
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
    );
  }

  // include
  bool include(int index) {
    if (top <= bottom) {
      return top <= index && index <= bottom;
    } else {
      return index <= bottom || top <= index;
    }
  }

  // lentgh
  int get length {
    if (top <= bottom) {
      return bottom - top + 1;
    } else {
      return limit - top + bottom + 1;
    }
  }
}
