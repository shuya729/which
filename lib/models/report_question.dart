import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class ReportQuestion {
  const ReportQuestion({
    required this.authId,
    required this.questionId,
    required this.creAt,
  });

  final String authId;
  final String questionId;
  final DateTime creAt;

  static Map<String, dynamic> forSet(String authId, String questionId) {
    return <String, dynamic>{
      'authId': authId,
      'questionId': questionId,
      'creAt': FieldValue.serverTimestamp(),
    };
  }

  // hashCode
  @override
  int get hashCode => authId.hashCode ^ questionId.hashCode ^ creAt.hashCode;

  // operator ==
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final ReportQuestion otherReportQuestion = other as ReportQuestion;
    return authId == otherReportQuestion.authId &&
        questionId == otherReportQuestion.questionId &&
        creAt == otherReportQuestion.creAt;
  }
}
