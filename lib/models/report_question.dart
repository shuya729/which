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

  // toFirestore
  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'authId': authId,
      'questionId': questionId,
      'creAt': creAt,
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
