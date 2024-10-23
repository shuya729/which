import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Vote {
  const Vote({
    required this.questionId,
    required this.authId,
    required this.vote,
    required this.creAt,
  });

  final String questionId;
  final String authId;
  final int vote;
  final DateTime creAt;

  static Map<String, dynamic> forSet(
    String questionId,
    String authId,
    int vote,
  ) {
    return <String, dynamic>{
      'questionId': questionId,
      'authId': authId,
      'vote': vote,
      'creAt': FieldValue.serverTimestamp(),
    };
  }

  factory Vote.fromFirestore(Map<String, dynamic> data) {
    return Vote(
      questionId: data['questionId'] as String? ?? '',
      authId: data['authId'] as String? ?? '',
      vote: data['vote'] as int? ?? 0,
      creAt: (data['creAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // copyWith
  Vote copyWith({
    String? questionId,
    String? authId,
    int? vote,
    DateTime? creAt,
  }) {
    return Vote(
      questionId: questionId ?? this.questionId,
      authId: authId ?? this.authId,
      vote: vote ?? this.vote,
      creAt: creAt ?? this.creAt,
    );
  }

  @override
  int get hashCode =>
      questionId.hashCode ^ authId.hashCode ^ vote.hashCode ^ creAt.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Vote &&
        questionId == other.questionId &&
        authId == other.authId &&
        vote == other.vote &&
        creAt == other.creAt;
  }
}
