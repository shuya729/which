import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class UserId {
  const UserId({
    required this.userId,
    required this.authId,
    required this.creAt,
  });

  final String userId;
  final String authId;
  final DateTime creAt;

  // fromFirestore
  factory UserId.fromFirestore(Map<String, dynamic> data) {
    return UserId(
      userId: data['userId'] as String? ?? '',
      authId: data['authId'] as String? ?? '',
      creAt: (data['creAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // copyWith
  UserId copyWith({
    String? userId,
    String? authId,
    DateTime? creAt,
    DateTime? updAt,
  }) {
    return UserId(
      userId: userId ?? this.userId,
      authId: authId ?? this.authId,
      creAt: creAt ?? this.creAt,
    );
  }

  // hashCode
  @override
  int get hashCode => userId.hashCode ^ authId.hashCode ^ creAt.hashCode;

  // operator ==
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserId &&
        other.userId == userId &&
        other.authId == authId &&
        other.creAt == creAt;
  }
}
