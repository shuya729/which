// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TermsImpl _$$TermsImplFromJson(Map<String, dynamic> json) => _$TermsImpl(
      type: json['type'] as String,
      text: json['text'] as String,
      indent: (json['indent'] as num).toInt(),
    );

Map<String, dynamic> _$$TermsImplToJson(_$TermsImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'text': instance.text,
      'indent': instance.indent,
    };
