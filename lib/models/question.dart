import 'package:freezed_annotation/freezed_annotation.dart';

part 'question.freezed.dart';
part 'question.g.dart';

@freezed
class Question with _$Question {
  const factory Question({
    required String questionId,
    required String authId,
    required String question,
    required String answer1,
    required String answer2,
    required int readCOunt,
    required int answer1Count,
    required int answer2Count,
    required List<int> vector,
    required bool editedFlg,
    required bool hiddenFlg,
    required bool deletedFlg,
    required bool rejectedFlg,
    required DateTime creAt,
    required DateTime updAt,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}
