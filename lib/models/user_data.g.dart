// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDataImpl _$$UserDataImplFromJson(Map<String, dynamic> json) =>
    _$UserDataImpl(
      authId: json['authId'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      anonymousFlg: json['anonymousFlg'] as bool,
      deletedFlg: json['deletedFlg'] as bool,
      rejectedFlg: json['rejectedFlg'] as bool,
      creAt: DateTime.parse(json['creAt'] as String),
      updAt: DateTime.parse(json['updAt'] as String),
    );

Map<String, dynamic> _$$UserDataImplToJson(_$UserDataImpl instance) =>
    <String, dynamic>{
      'authId': instance.authId,
      'userId': instance.userId,
      'name': instance.name,
      'image': instance.image,
      'anonymousFlg': instance.anonymousFlg,
      'deletedFlg': instance.deletedFlg,
      'rejectedFlg': instance.rejectedFlg,
      'creAt': instance.creAt.toIso8601String(),
      'updAt': instance.updAt.toIso8601String(),
    };
