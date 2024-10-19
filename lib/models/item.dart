import 'package:flutter/material.dart';

@immutable
class Item {
  const Item({
    required this.questionId,
    required this.authId,
    required this.creAt,
    required this.updAt,
  });

  final String questionId;
  final String authId;
  final DateTime creAt;
  final DateTime updAt;

  // fromFirestore
  factory Item.fromFirestore(Map<String, dynamic> map) {
    return Item(
      questionId: map['questionId'] as String? ?? '',
      authId: map['authId'] as String? ?? '',
      creAt: (map['creAt'] as DateTime?) ?? DateTime.now(),
      updAt: (map['updAt'] as DateTime?) ?? DateTime.now(),
    );
  }

  // toFirestore
  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'questionId': questionId,
      'authId': authId,
      'creAt': creAt,
      'updAt': updAt,
    };
  }

  // copyWith
  Item copyWith({
    int? index,
    String? authId,
    String? questionId,
    DateTime? creAt,
    DateTime? updAt,
  }) {
    return Item(
      questionId: questionId ?? this.questionId,
      authId: authId ?? this.authId,
      creAt: creAt ?? this.creAt,
      updAt: updAt ?? this.updAt,
    );
  }

  @override
  int get hashCode =>
      questionId.hashCode ^ authId.hashCode ^ creAt.hashCode ^ updAt.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Item otherItem = other as Item;
    return otherItem.questionId == questionId &&
        otherItem.authId == authId &&
        otherItem.creAt == creAt &&
        otherItem.updAt == updAt;
  }
}
