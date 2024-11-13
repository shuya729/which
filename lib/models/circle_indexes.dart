import 'package:flutter/foundation.dart';
import 'package:which/models/indexes.dart';

@immutable
class CircleIndexes extends Indexes {
  static const int limit = 80;
  static const int loadCount = 20;
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
      top = _calcTop(this.top, this.bottom, bottom);
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
  CircleIndexes changePage(final int value) {
    return copyWith(current: value, multiplier: value ~/ limit);
  }

  @override
  CircleIndexes loading() {
    final int? top = _calcTop(this.top, bottom, bottom + loadCount);
    return copyWith(top: top, load: bottom);
  }

  @override
  CircleIndexes loaded(int length) {
    if (top == 0 && bottom == 0 && length > 0) length--;
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
  bool showAd(final int page) {
    if (!kIsWeb && page % loadCount == 18) {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool hasPage(final int page) {
    final int topPage = top <= current
        ? top + multiplier * limit
        : top + (multiplier - 1) * limit;
    final int bottomPage = current <= bottom
        ? bottom + multiplier * limit
        : bottom + (multiplier + 1) * limit;
    return topPage <= page && page <= bottomPage;
  }

  @override
  int pageIndex(final int page) {
    return page % limit;
  }

  int? _calcTop(int top, int bottom, int bottomValue) {
    if (top <= bottom) {
      final int preTop = top + limit;
      if (bottom < preTop && preTop <= bottomValue) {
        return bottomValue + 1;
      }
    } else {
      if (bottom < top && top <= bottomValue) {
        return bottomValue + 1;
      }
    }
    return null;
  }
}
