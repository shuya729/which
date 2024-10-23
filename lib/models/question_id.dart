import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class QuestionId {
  const QuestionId({
    required this.questionId,
    required this.authId,
    required this.creAt,
  });

  final String questionId;
  final String authId;
  final DateTime creAt;

  static Map<String, dynamic> forSet(String authId, String questionId) {
    return <String, dynamic>{
      'questionId': questionId,
      'authId': authId,
      'creAt': FieldValue.serverTimestamp(),
    };
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
    );
  }

  // fromFireatore
  factory QuestionId.fromFirestore(Map<String, dynamic> data) {
    return QuestionId(
      questionId: data['questionId'] as String? ?? '',
      authId: data['authId'] as String? ?? '',
      creAt: (data['creAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // hashCode
  @override
  int get hashCode => questionId.hashCode ^ authId.hashCode ^ creAt.hashCode;

  // operator ==
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final QuestionId otherQuestionId = other as QuestionId;
    return questionId == otherQuestionId.questionId &&
        authId == otherQuestionId.authId &&
        creAt == otherQuestionId.creAt;
  }
}
