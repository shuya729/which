// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentImpl _$$CommentImplFromJson(Map<String, dynamic> json) =>
    _$CommentImpl(
      commentId: json['commentId'] as String,
      tgtQuestionId: json['tgtQuestionId'] as String,
      tgtAnswer: (json['tgtAnswer'] as num).toInt(),
      authId: json['authId'] as String,
      comment: json['comment'] as String,
      likeCount: (json['likeCount'] as num).toInt(),
      editedFlg: json['editedFlg'] as bool,
      deletedFlg: json['deletedFlg'] as bool,
      rejectedFlg: json['rejectedFlg'] as bool,
      creAt: DateTime.parse(json['creAt'] as String),
      updAt: DateTime.parse(json['updAt'] as String),
    );

Map<String, dynamic> _$$CommentImplToJson(_$CommentImpl instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'tgtQuestionId': instance.tgtQuestionId,
      'tgtAnswer': instance.tgtAnswer,
      'authId': instance.authId,
      'comment': instance.comment,
      'likeCount': instance.likeCount,
      'editedFlg': instance.editedFlg,
      'deletedFlg': instance.deletedFlg,
      'rejectedFlg': instance.rejectedFlg,
      'creAt': instance.creAt.toIso8601String(),
      'updAt': instance.updAt.toIso8601String(),
    };
