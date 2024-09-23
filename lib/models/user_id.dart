import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_id.freezed.dart';
part 'user_id.g.dart';

@freezed
class UserId with _$UserId {
  const factory UserId({
    required String userId,
    required String authId,
    required DateTime creAt,
    required DateTime updAt,
  }) = _UserId;

  factory UserId.fromJson(Map<String, dynamic> json) => _$UserIdFromJson(json);
}
