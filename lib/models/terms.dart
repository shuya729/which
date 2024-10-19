import 'package:flutter/material.dart';

@immutable
class Terms {
  const Terms({
    required this.type,
    required this.text,
    required this.indent,
  });

  final String type;
  final String text;
  final int indent;

  // fromJson
  factory Terms.fromJson(Map<String, dynamic> json) {
    return Terms(
      type: json['type'] as String? ?? '',
      text: json['text'] as String? ?? '',
      indent: json['indent'] as int? ?? 0,
    );
  }

  // hashCode
  @override
  int get hashCode => type.hashCode ^ text.hashCode ^ indent.hashCode;

  // operator ==
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Terms otherTerms = other as Terms;
    return type == otherTerms.type &&
        text == otherTerms.text &&
        indent == otherTerms.indent;
  }
}
