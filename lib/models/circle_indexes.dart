import 'package:flutter/material.dart';
import 'package:which/models/indexes.dart';

@immutable
class CircleIndexes extends Indexes {
  static const int limit = 80;
  static const int loadCount = Indexes.loadCount;
  final int multiplier;

  const CircleIndexes({
    int top = 0,
    int current = 0,
    int bottom = 0,
    int load = 0,
    this.multiplier = 0,
  }) : super(
          top: top % limit,
          current: current % limit,
          bottom: bottom % limit,
          load: load % limit,
        );

  // copyWith
  @override
  CircleIndexes copyWith({
    int? top,
    int? current,
    int? bottom,
    int? load,
    int? multiplier,
  }) {
    if (bottom != null) {
      if (this.top <= this.bottom) {
        final int preTop = this.top + limit;
        if (this.bottom < preTop && preTop <= bottom) {
          top = bottom + 1;
        }
      } else {
        if (this.bottom < this.top && this.top <= bottom) {
          top = bottom + 1;
        }
      }
    }
    return CircleIndexes(
      top: top ?? this.top,
      current: current ?? this.current,
      bottom: bottom ?? this.bottom,
      load: load ?? this.load,
      multiplier: multiplier ?? this.multiplier,
    );
  }

  @override
  CircleIndexes changePage(int value) {
    print('top: $top, current: $value, bottom: $bottom, load: $load');
    return copyWith(current: value, multiplier: value ~/ limit);
  }

  @override
  CircleIndexes loading() {
    return copyWith(load: bottom);
  }

  @override
  CircleIndexes loaded(int length) {
    if (top == 0 && bottom == 0) length--;
    int? load;
    if (length > loadCount) load = bottom + length - loadCount;
    return copyWith(bottom: bottom + length, load: load);
  }

  @override
  bool canLoad() {
    final int current =
        this.current >= top ? this.current : this.current + limit;
    final int load = this.load >= top ? this.load : this.load + limit;
    return current > load;
  }

  @override
  bool hasPage(int page) {
    final int topPage = top <= current
        ? top + multiplier * limit
        : top + (multiplier - 1) * limit;
    final int bottomPage = current <= bottom
        ? bottom + multiplier * limit
        : bottom + (multiplier + 1) * limit;
    return topPage <= page && page <= bottomPage;
  }

  @override
  int pageIndex(int page) {
    return page % limit;
  }
}
