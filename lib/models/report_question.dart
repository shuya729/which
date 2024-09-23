import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_question.freezed.dart';
part 'report_question.g.dart';

@freezed
class ReportQuestion with _$ReportQuestion {
  const factory ReportQuestion({
    required String authId,
    required String tgtQuestionId,
    required String tgtAnswer,
    required DateTime creAt,
  }) = _ReportQuestion;

  factory ReportQuestion.fromJson(Map<String, dynamic> json) =>
      _$ReportQuestionFromJson(json);
}
