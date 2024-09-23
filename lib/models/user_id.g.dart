// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_id.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserIdImpl _$$UserIdImplFromJson(Map<String, dynamic> json) => _$UserIdImpl(
      userId: json['userId'] as String,
      authId: json['authId'] as String,
      creAt: DateTime.parse(json['creAt'] as String),
      updAt: DateTime.parse(json['updAt'] as String),
    );

Map<String, dynamic> _$$UserIdImplToJson(_$UserIdImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'authId': instance.authId,
      'creAt': instance.creAt.toIso8601String(),
      'updAt': instance.updAt.toIso8601String(),
    };
