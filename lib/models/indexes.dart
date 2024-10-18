import 'package:flutter/material.dart';

@immutable
class Indexes {
  static const int loadCount = 20;
  final int top;
  final int current;
  final int bottom;
  final int load;

  const Indexes({
    this.top = 0,
    this.current = 0,
    this.bottom = 0,
    this.load = 0,
  });

  // copyWith
  Indexes copyWith({
    int? top,
    int? current,
    int? bottom,
    int? load,
  }) {
    return Indexes(
      top: top ?? this.top,
      current: current ?? this.current,
      bottom: bottom ?? this.bottom,
      load: load ?? this.load,
    );
  }

  // changePage
  Indexes changePage(int value) {
    return copyWith(current: value);
  }

  // loading
  Indexes loading() {
    return copyWith(load: bottom);
  }

  // loaded
  Indexes loaded(int length) {
    if (top == 0 && bottom == 0) length--;
    int? load;
    if (length > loadCount) load = bottom + length - loadCount;
    return copyWith(bottom: bottom + length, load: load);
  }

  // canLoad
  bool canLoad() {
    return current > load;
  }

  // hasPage
  bool hasPage(int page) {
    return top <= page && page <= bottom;
  }

  // pageNum
  int pageIndex(int page) {
    return page;
  }

  // hashCode
  @override
  int get hashCode =>
      top.hashCode ^ current.hashCode ^ bottom.hashCode ^ load.hashCode;

  // ==
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Indexes &&
        other.top == top &&
        other.current == current &&
        other.bottom == bottom &&
        other.load == load;
  }
}
