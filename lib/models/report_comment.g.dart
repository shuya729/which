// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportCommentImpl _$$ReportCommentImplFromJson(Map<String, dynamic> json) =>
    _$ReportCommentImpl(
      authId: json['authId'] as String,
      tgtQuestionId: json['tgtQuestionId'] as String,
      tgtAnswer: json['tgtAnswer'] as String,
      tgtCommentId: json['tgtCommentId'] as String,
      creAt: DateTime.parse(json['creAt'] as String),
    );

Map<String, dynamic> _$$ReportCommentImplToJson(_$ReportCommentImpl instance) =>
    <String, dynamic>{
      'authId': instance.authId,
      'tgtQuestionId': instance.tgtQuestionId,
      'tgtAnswer': instance.tgtAnswer,
      'tgtCommentId': instance.tgtCommentId,
      'creAt': instance.creAt.toIso8601String(),
    };
