import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class UserInfo {
  const UserInfo({
    required this.userId,
    required this.authId,
    required this.lastAt,
    required this.anonymousFlg,
  });

  final String userId;
  final String authId;
  final DateTime lastAt;
  final bool anonymousFlg;

  static Map<String, dynamic> forLogin(String authId, bool anonymousFlg) {
    return <String, dynamic>{
      'userId': authId,
      'authId': authId,
      'lastAt': FieldValue.serverTimestamp(),
      'anonymousFlg': anonymousFlg,
    };
  }

  // copyWith
  UserInfo copyWith({
    String? userId,
    String? authId,
    DateTime? lastAt,
    bool? anonymousFlg,
  }) {
    return UserInfo(
      userId: userId ?? this.userId,
      authId: authId ?? this.authId,
      lastAt: lastAt ?? this.lastAt,
      anonymousFlg: anonymousFlg ?? this.anonymousFlg,
    );
  }

  // hashCode
  @override
  int get hashCode =>
      userId.hashCode ^
      authId.hashCode ^
      lastAt.hashCode ^
      anonymousFlg.hashCode;

  // operator ==
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserInfo &&
        other.userId == userId &&
        other.authId == authId &&
        other.lastAt == lastAt &&
        other.anonymousFlg == anonymousFlg;
  }
}
