// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionImpl _$$QuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuestionImpl(
      questionId: json['questionId'] as String,
      authId: json['authId'] as String,
      question: json['question'] as String,
      answer1: json['answer1'] as String,
      answer2: json['answer2'] as String,
      readCOunt: (json['readCOunt'] as num).toInt(),
      answer1Count: (json['answer1Count'] as num).toInt(),
      answer2Count: (json['answer2Count'] as num).toInt(),
      vector: (json['vector'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      editedFlg: json['editedFlg'] as bool,
      hiddenFlg: json['hiddenFlg'] as bool,
      deletedFlg: json['deletedFlg'] as bool,
      rejectedFlg: json['rejectedFlg'] as bool,
      creAt: DateTime.parse(json['creAt'] as String),
      updAt: DateTime.parse(json['updAt'] as String),
    );

Map<String, dynamic> _$$QuestionImplToJson(_$QuestionImpl instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'authId': instance.authId,
      'question': instance.question,
      'answer1': instance.answer1,
      'answer2': instance.answer2,
      'readCOunt': instance.readCOunt,
      'answer1Count': instance.answer1Count,
      'answer2Count': instance.answer2Count,
      'vector': instance.vector,
      'editedFlg': instance.editedFlg,
      'hiddenFlg': instance.hiddenFlg,
      'deletedFlg': instance.deletedFlg,
      'rejectedFlg': instance.rejectedFlg,
      'creAt': instance.creAt.toIso8601String(),
      'updAt': instance.updAt.toIso8601String(),
    };
