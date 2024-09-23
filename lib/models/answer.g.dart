// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnswerImpl _$$AnswerImplFromJson(Map<String, dynamic> json) => _$AnswerImpl(
      authId: json['authId'] as String,
      tgtQuestionId: json['tgtQuestionId'] as String,
      tgtAnswer: json['tgtAnswer'] as String,
      likeCount: (json['likeCount'] as num).toInt(),
      creAt: DateTime.parse(json['creAt'] as String),
    );

Map<String, dynamic> _$$AnswerImplToJson(_$AnswerImpl instance) =>
    <String, dynamic>{
      'authId': instance.authId,
      'tgtQuestionId': instance.tgtQuestionId,
      'tgtAnswer': instance.tgtAnswer,
      'likeCount': instance.likeCount,
      'creAt': instance.creAt.toIso8601String(),
    };
