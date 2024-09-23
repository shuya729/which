// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReportComment _$ReportCommentFromJson(Map<String, dynamic> json) {
  return _ReportComment.fromJson(json);
}

/// @nodoc
mixin _$ReportComment {
  String get authId => throw _privateConstructorUsedError;
  String get tgtQuestionId => throw _privateConstructorUsedError;
  String get tgtAnswer => throw _privateConstructorUsedError;
  String get tgtCommentId => throw _privateConstructorUsedError;
  DateTime get creAt => throw _privateConstructorUsedError;

  /// Serializes this ReportComment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportCommentCopyWith<ReportComment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportCommentCopyWith<$Res> {
  factory $ReportCommentCopyWith(
          ReportComment value, $Res Function(ReportComment) then) =
      _$ReportCommentCopyWithImpl<$Res, ReportComment>;
  @useResult
  $Res call(
      {String authId,
      String tgtQuestionId,
      String tgtAnswer,
      String tgtCommentId,
      DateTime creAt});
}

/// @nodoc
class _$ReportCommentCopyWithImpl<$Res, $Val extends ReportComment>
    implements $ReportCommentCopyWith<$Res> {
  _$ReportCommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authId = null,
    Object? tgtQuestionId = null,
    Object? tgtAnswer = null,
    Object? tgtCommentId = null,
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
      tgtCommentId: null == tgtCommentId
          ? _value.tgtCommentId
          : tgtCommentId // ignore: cast_nullable_to_non_nullable
              as String,
      creAt: null == creAt
          ? _value.creAt
          : creAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportCommentImplCopyWith<$Res>
    implements $ReportCommentCopyWith<$Res> {
  factory _$$ReportCommentImplCopyWith(
          _$ReportCommentImpl value, $Res Function(_$ReportCommentImpl) then) =
      __$$ReportCommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String authId,
      String tgtQuestionId,
      String tgtAnswer,
      String tgtCommentId,
      DateTime creAt});
}

/// @nodoc
class __$$ReportCommentImplCopyWithImpl<$Res>
    extends _$ReportCommentCopyWithImpl<$Res, _$ReportCommentImpl>
    implements _$$ReportCommentImplCopyWith<$Res> {
  __$$ReportCommentImplCopyWithImpl(
      _$ReportCommentImpl _value, $Res Function(_$ReportCommentImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReportComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authId = null,
    Object? tgtQuestionId = null,
    Object? tgtAnswer = null,
    Object? tgtCommentId = null,
    Object? creAt = null,
  }) {
    return _then(_$ReportCommentImpl(
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
      tgtCommentId: null == tgtCommentId
          ? _value.tgtCommentId
          : tgtCommentId // ignore: cast_nullable_to_non_nullable
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
class _$ReportCommentImpl implements _ReportComment {
  const _$ReportCommentImpl(
      {required this.authId,
      required this.tgtQuestionId,
      required this.tgtAnswer,
      required this.tgtCommentId,
      required this.creAt});

  factory _$ReportCommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportCommentImplFromJson(json);

  @override
  final String authId;
  @override
  final String tgtQuestionId;
  @override
  final String tgtAnswer;
  @override
  final String tgtCommentId;
  @override
  final DateTime creAt;

  @override
  String toString() {
    return 'ReportComment(authId: $authId, tgtQuestionId: $tgtQuestionId, tgtAnswer: $tgtAnswer, tgtCommentId: $tgtCommentId, creAt: $creAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportCommentImpl &&
            (identical(other.authId, authId) || other.authId == authId) &&
            (identical(other.tgtQuestionId, tgtQuestionId) ||
                other.tgtQuestionId == tgtQuestionId) &&
            (identical(other.tgtAnswer, tgtAnswer) ||
                other.tgtAnswer == tgtAnswer) &&
            (identical(other.tgtCommentId, tgtCommentId) ||
                other.tgtCommentId == tgtCommentId) &&
            (identical(other.creAt, creAt) || other.creAt == creAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, authId, tgtQuestionId, tgtAnswer, tgtCommentId, creAt);

  /// Create a copy of ReportComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportCommentImplCopyWith<_$ReportCommentImpl> get copyWith =>
      __$$ReportCommentImplCopyWithImpl<_$ReportCommentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportCommentImplToJson(
      this,
    );
  }
}

abstract class _ReportComment implements ReportComment {
  const factory _ReportComment(
      {required final String authId,
      required final String tgtQuestionId,
      required final String tgtAnswer,
      required final String tgtCommentId,
      required final DateTime creAt}) = _$ReportCommentImpl;

  factory _ReportComment.fromJson(Map<String, dynamic> json) =
      _$ReportCommentImpl.fromJson;

  @override
  String get authId;
  @override
  String get tgtQuestionId;
  @override
  String get tgtAnswer;
  @override
  String get tgtCommentId;
  @override
  DateTime get creAt;

  /// Create a copy of ReportComment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportCommentImplCopyWith<_$ReportCommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
