// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReportQuestion _$ReportQuestionFromJson(Map<String, dynamic> json) {
  return _ReportQuestion.fromJson(json);
}

/// @nodoc
mixin _$ReportQuestion {
  String get authId => throw _privateConstructorUsedError;
  String get tgtQuestionId => throw _privateConstructorUsedError;
  String get tgtAnswer => throw _privateConstructorUsedError;
  DateTime get creAt => throw _privateConstructorUsedError;

  /// Serializes this ReportQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportQuestionCopyWith<ReportQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportQuestionCopyWith<$Res> {
  factory $ReportQuestionCopyWith(
          ReportQuestion value, $Res Function(ReportQuestion) then) =
      _$ReportQuestionCopyWithImpl<$Res, ReportQuestion>;
  @useResult
  $Res call(
      {String authId, String tgtQuestionId, String tgtAnswer, DateTime creAt});
}

/// @nodoc
class _$ReportQuestionCopyWithImpl<$Res, $Val extends ReportQuestion>
    implements $ReportQuestionCopyWith<$Res> {
  _$ReportQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authId = null,
    Object? tgtQuestionId = null,
    Object? tgtAnswer = null,
    Object? creAt = null,
  }) {
    return _then(_value.copyWith(
      authId: null == authId
          ? _value.authId
          : authId // ignore: cast_nullable_to_non_nullable
              as String,
      tgtQuestionId: null == tgtQuestionId
          ? _value.tgtQuestionId
          : tgtQuestionId // ignore: cast_nullable_to_non_nullable
              as String,
      tgtAnswer: null == tgtAnswer
          ? _value.tgtAnswer
          : tgtAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      creAt: null == creAt
          ? _value.creAt
          : creAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportQuestionImplCopyWith<$Res>
    implements $ReportQuestionCopyWith<$Res> {
  factory _$$ReportQuestionImplCopyWith(_$ReportQuestionImpl value,
          $Res Function(_$ReportQuestionImpl) then) =
      __$$ReportQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String authId, String tgtQuestionId, String tgtAnswer, DateTime creAt});
}

/// @nodoc
class __$$ReportQuestionImplCopyWithImpl<$Res>
    extends _$ReportQuestionCopyWithImpl<$Res, _$ReportQuestionImpl>
    implements _$$ReportQuestionImplCopyWith<$Res> {
  __$$ReportQuestionImplCopyWithImpl(
      _$ReportQuestionImpl _value, $Res Function(_$ReportQuestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReportQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authId = null,
    Object? tgtQuestionId = null,
    Object? tgtAnswer = null,
    Object? creAt = null,
  }) {
    return _then(_$ReportQuestionImpl(
      authId: null == authId
          ? _value.authId
          : authId // ignore: cast_nullable_to_non_nullable
              as String,
      tgtQuestionId: null == tgtQuestionId
          ? _value.tgtQuestionId
          : tgtQuestionId // ignore: cast_nullable_to_non_nullable
              as String,
      tgtAnswer: null == tgtAnswer
          ? _value.tgtAnswer
          : tgtAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      creAt: null == creAt
          ? _value.creAt
          : creAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportQuestionImpl implements _ReportQuestion {
  const _$ReportQuestionImpl(
      {required this.authId,
      required this.tgtQuestionId,
      required this.tgtAnswer,
      required this.creAt});

  factory _$ReportQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportQuestionImplFromJson(json);

  @override
  final String authId;
  @override
  final String tgtQuestionId;
  @override
  final String tgtAnswer;
  @override
  final DateTime creAt;

  @override
  String toString() {
    return 'ReportQuestion(authId: $authId, tgtQuestionId: $tgtQuestionId, tgtAnswer: $tgtAnswer, creAt: $creAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportQuestionImpl &&
            (identical(other.authId, authId) || other.authId == authId) &&
            (identical(other.tgtQuestionId, tgtQuestionId) ||
                other.tgtQuestionId == tgtQuestionId) &&
            (identical(other.tgtAnswer, tgtAnswer) ||
                other.tgtAnswer == tgtAnswer) &&
            (identical(other.creAt, creAt) || other.creAt == creAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, authId, tgtQuestionId, tgtAnswer, creAt);

  /// Create a copy of ReportQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportQuestionImplCopyWith<_$ReportQuestionImpl> get copyWith =>
      __$$ReportQuestionImplCopyWithImpl<_$ReportQuestionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportQuestionImplToJson(
      this,
    );
  }
}

abstract class _ReportQuestion implements ReportQuestion {
  const factory _ReportQuestion(
      {required final String authId,
      required final String tgtQuestionId,
      required final String tgtAnswer,
      required final DateTime creAt}) = _$ReportQuestionImpl;

  factory _ReportQuestion.fromJson(Map<String, dynamic> json) =
      _$ReportQuestionImpl.fromJson;

  @override
  String get authId;
  @override
  String get tgtQuestionId;
  @override
  String get tgtAnswer;
  @override
  DateTime get creAt;

  /// Create a copy of ReportQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportQuestionImplCopyWith<_$ReportQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
