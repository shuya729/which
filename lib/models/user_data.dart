import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class UserData {
  const UserData({
    required this.authId,
    required this.userId,
    required this.name,
    required this.image,
    required this.anonymousFlg,
    required this.deletedFlg,
    required this.rejectedFlg,
    required this.creAt,
    required this.updAt,
  });

  final String authId;
  final String userId;
  final String name;
  final String image;
  final bool anonymousFlg;
  final bool deletedFlg;
  final bool rejectedFlg;
  final DateTime creAt;
  final DateTime updAt;

  static Map<String, dynamic> forSet(String authId, bool isAnonymous) {
    return <String, dynamic>{
      'authId': authId,
      'userId': authId,
      'name': '',
      'image': '',
      'anonymousFlg': isAnonymous,
      'deletedFlg': false,
      'rejectedFlg': false,
      'creAt': FieldValue.serverTimestamp(),
      'updAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> forUpdate(
    String? name,
    String? image,
    bool? anonymousFlg,
  ) {
    final Map<String, dynamic> data = {'updAt': FieldValue.serverTimestamp()};
    if (name != null) data['name'] = name;
    if (image != null) data['image'] = image;
    if (anonymousFlg != null) data['anonymousFlg'] = anonymousFlg;
    return data;
  }

  // fromFirestore
  factory UserData.fromFirestore(Map<String, dynamic> data) {
    return UserData(
      authId: data['authId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      image: data['image'] as String? ?? '',
      anonymousFlg: data['anonymousFlg'] as bool? ?? true,
      deletedFlg: data['deletedFlg'] as bool? ?? false,
      rejectedFlg: data['rejectedFlg'] as bool? ?? false,
      creAt: (data['creAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updAt: (data['updAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // copyWith
  UserData copyWith({
    String? authId,
    String? userId,
    String? name,
    String? image,
    bool? anonymousFlg,
    bool? deletedFlg,
    bool? rejectedFlg,
    DateTime? creAt,
    DateTime? updAt,
  }) {
    return UserData(
      authId: authId ?? this.authId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      image: image ?? this.image,
      anonymousFlg: anonymousFlg ?? this.anonymousFlg,
      deletedFlg: deletedFlg ?? this.deletedFlg,
      rejectedFlg: rejectedFlg ?? this.rejectedFlg,
      creAt: creAt ?? this.creAt,
      updAt: updAt ?? this.updAt,
    );
  }

  // hashCode
  @override
  int get hashCode =>
      authId.hashCode ^
      userId.hashCode ^
      name.hashCode ^
      image.hashCode ^
      anonymousFlg.hashCode ^
      deletedFlg.hashCode ^
      rejectedFlg.hashCode ^
      creAt.hashCode ^
      updAt.hashCode;

  // operator ==
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final UserData otherUserData = other as UserData;
    return authId == otherUserData.authId &&
        userId == otherUserData.userId &&
        name == otherUserData.name &&
        image == otherUserData.image &&
        anonymousFlg == otherUserData.anonymousFlg &&
        deletedFlg == otherUserData.deletedFlg &&
        rejectedFlg == otherUserData.rejectedFlg &&
        creAt == otherUserData.creAt &&
        updAt == otherUserData.updAt;
  }
}
