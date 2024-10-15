import 'package:flutter/material.dart';

@immutable
class ReportComment {
  const ReportComment({
    required this.authId,
    required this.tgtQuestionId,
    required this.tgtAnswer,
    required this.tgtCommentId,
    required this.creAt,
  });

  final String authId;
  final String tgtQuestionId;
  final int tgtAnswer;
  final String tgtCommentId;
  final DateTime creAt;

  // toFirestore
  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'authId': authId,
      'tgtQuestionId': tgtQuestionId,
      'tgtAnswer': tgtAnswer,
      'tgtCommentId': tgtCommentId,
      'creAt': creAt,
    };
  }

  // hashCode
  @override
  int get hashCode =>
      authId.hashCode ^
      tgtQuestionId.hashCode ^
      tgtAnswer.hashCode ^
      tgtCommentId.hashCode ^
      creAt.hashCode;

  // operator ==
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final ReportComment otherReportComment = other as ReportComment;
    return authId == otherReportComment.authId &&
        tgtQuestionId == otherReportComment.tgtQuestionId &&
        tgtAnswer == otherReportComment.tgtAnswer &&
        tgtCommentId == otherReportComment.tgtCommentId &&
        creAt == otherReportComment.creAt;
  }
}
