// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportQuestionImpl _$$ReportQuestionImplFromJson(Map<String, dynamic> json) =>
    _$ReportQuestionImpl(
      authId: json['authId'] as String,
      tgtQuestionId: json['tgtQuestionId'] as String,
      tgtAnswer: json['tgtAnswer'] as String,
      creAt: DateTime.parse(json['creAt'] as String),
    );

Map<String, dynamic> _$$ReportQuestionImplToJson(
        _$ReportQuestionImpl instance) =>
    <String, dynamic>{
      'authId': instance.authId,
      'tgtQuestionId': instance.tgtQuestionId,
      'tgtAnswer': instance.tgtAnswer,
      'creAt': instance.creAt.toIso8601String(),
    };
