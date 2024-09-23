import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

@freezed
class Comment with _$Comment {
  const factory Comment({
    required String commentId,
    required String tgtQuestionId,
    required int tgtAnswer,
    required String authId,
    required String comment,
    required int likeCount,
    required bool editedFlg,
    required bool deletedFlg,
    required bool rejectedFlg,
    required DateTime creAt,
    required DateTime updAt,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}
