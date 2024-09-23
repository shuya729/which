import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_comment.freezed.dart';
part 'report_comment.g.dart';

@freezed
class ReportComment with _$ReportComment {
  const factory ReportComment({
    required String authId,
    required String tgtQuestionId,
    required String tgtAnswer,
    required String tgtCommentId,
    required DateTime creAt,
  }) = _ReportComment;

  factory ReportComment.fromJson(Map<String, dynamic> json) =>
      _$ReportCommentFromJson(json);
}
