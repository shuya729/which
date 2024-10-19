import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class QuestionId {
  const QuestionId({
    required this.questionId,
    required this.authId,
    required this.creAt,
    required this.updAt,
  });

  final String questionId;
  final String authId;
  final DateTime creAt;
  final DateTime updAt;

  // init
  factory QuestionId.init(String questionId, String authId) {
    return QuestionId(
      questionId: questionId,
      authId: authId,
      creAt: DateTime.now(),
      updAt: DateTime.now(),
    );
  }

  // fromQuestion
  factory QuestionId.fromQuestion({
    required String questionId,
    required String authId,
  }) {
    return QuestionId(
      questionId: questionId,
      authId: authId,
      creAt: DateTime.now(),
      updAt: DateTime.now(),
    );
  }

  // fromFireatore
  factory QuestionId.fromFirestore(Map<String, dynamic> data) {
    return QuestionId(
      questionId: data['questionId'] as String? ?? '',
      authId: data['authId'] as String? ?? '',
      creAt: (data['creAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updAt: (data['updAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
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

  // hashCode
  @override
  int get hashCode =>
      questionId.hashCode ^ authId.hashCode ^ creAt.hashCode ^ updAt.hashCode;

  // operator ==
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final QuestionId otherQuestionId = other as QuestionId;
    return questionId == otherQuestionId.questionId &&
        authId == otherQuestionId.authId &&
        creAt == otherQuestionId.creAt &&
        updAt == otherQuestionId.updAt;
  }
}
