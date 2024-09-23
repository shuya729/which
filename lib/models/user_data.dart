import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

@freezed
class UserData with _$UserData {
  const factory UserData({
    required String authId,
    required String userId,
    required String name,
    required String image,
    required bool anonymousFlg,
    required bool deletedFlg,
    required bool rejectedFlg,
    required DateTime creAt,
    required DateTime updAt,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
