// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return _Comment.fromJson(json);
}

/// @nodoc
mixin _$Comment {
  String get commentId => throw _privateConstructorUsedError;
  String get tgtQuestionId => throw _privateConstructorUsedError;
  int get tgtAnswer => throw _privateConstructorUsedError;
  String get authId => throw _privateConstructorUsedError;
  String get comment => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  bool get editedFlg => throw _privateConstructorUsedError;
  bool get deletedFlg => throw _privateConstructorUsedError;
  bool get rejectedFlg => throw _privateConstructorUsedError;
  DateTime get creAt => throw _privateConstructorUsedError;
  DateTime get updAt => throw _privateConstructorUsedError;

  /// Serializes this Comment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentCopyWith<Comment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentCopyWith<$Res> {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) then) =
      _$CommentCopyWithImpl<$Res, Comment>;
  @useResult
  $Res call(
      {String commentId,
      String tgtQuestionId,
      int tgtAnswer,
      String authId,
      String comment,
      int likeCount,
      bool editedFlg,
      bool deletedFlg,
      bool rejectedFlg,
      DateTime creAt,
      DateTime updAt});
}

/// @nodoc
class _$CommentCopyWithImpl<$Res, $Val extends Comment>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentId = null,
    Object? tgtQuestionId = null,
    Object? tgtAnswer = null,
    Object? authId = null,
    Object? comment = null,
    Object? likeCount = null,
    Object? editedFlg = null,
    Object? deletedFlg = null,
    Object? rejectedFlg = null,
    Object? creAt = null,
    Object? updAt = null,
  }) {
    return _then(_value.copyWith(
      commentId: null == commentId
          ? _value.commentId
          : commentId // ignore: cast_nullable_to_non_nullable
              as String,
      tgtQuestionId: null == tgtQuestionId
          ? _value.tgtQuestionId
          : tgtQuestionId // ignore: cast_nullable_to_non_nullable
              as String,
      tgtAnswer: null == tgtAnswer
          ? _value.tgtAnswer
          : tgtAnswer // ignore: cast_nullable_to_non_nullable
              as int,
      authId: null == authId
          ? _value.authId
          : authId // ignore: cast_nullable_to_non_nullable
              as String,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      editedFlg: null == editedFlg
          ? _value.editedFlg
          : editedFlg // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedFlg: null == deletedFlg
          ? _value.deletedFlg
          : deletedFlg // ignore: cast_nullable_to_non_nullable
              as bool,
      rejectedFlg: null == rejectedFlg
          ? _value.rejectedFlg
          : rejectedFlg // ignore: cast_nullable_to_non_nullable
              as bool,
      creAt: null == creAt
          ? _value.creAt
          : creAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updAt: null == updAt
          ? _value.updAt
          : updAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentImplCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$$CommentImplCopyWith(
          _$CommentImpl value, $Res Function(_$CommentImpl) then) =
      __$$CommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String commentId,
      String tgtQuestionId,
      int tgtAnswer,
      String authId,
      String comment,
      int likeCount,
      bool editedFlg,
      bool deletedFlg,
      bool rejectedFlg,
      DateTime creAt,
      DateTime updAt});
}

/// @nodoc
class __$$CommentImplCopyWithImpl<$Res>
    extends _$CommentCopyWithImpl<$Res, _$CommentImpl>
    implements _$$CommentImplCopyWith<$Res> {
  __$$CommentImplCopyWithImpl(
      _$CommentImpl _value, $Res Function(_$CommentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentId = null,
    Object? tgtQuestionId = null,
    Object? tgtAnswer = null,
    Object? authId = null,
    Object? comment = null,
    Object? likeCount = null,
    Object? editedFlg = null,
    Object? deletedFlg = null,
    Object? rejectedFlg = null,
    Object? creAt = null,
    Object? updAt = null,
  }) {
    return _then(_$CommentImpl(
      commentId: null == commentId
          ? _value.commentId
          : commentId // ignore: cast_nullable_to_non_nullable
              as String,
      tgtQuestionId: null == tgtQuestionId
          ? _value.tgtQuestionId
          : tgtQuestionId // ignore: cast_nullable_to_non_nullable
              as String,
      tgtAnswer: null == tgtAnswer
          ? _value.tgtAnswer
          : tgtAnswer // ignore: cast_nullable_to_non_nullable
              as int,
      authId: null == authId
          ? _value.authId
          : authId // ignore: cast_nullable_to_non_nullable
              as String,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      editedFlg: null == editedFlg
          ? _value.editedFlg
          : editedFlg // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedFlg: null == deletedFlg
          ? _value.deletedFlg
          : deletedFlg // ignore: cast_nullable_to_non_nullable
              as bool,
      rejectedFlg: null == rejectedFlg
          ? _value.rejectedFlg
          : rejectedFlg // ignore: cast_nullable_to_non_nullable
              as bool,
      creAt: null == creAt
          ? _value.creAt
          : creAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updAt: null == updAt
          ? _value.updAt
          : updAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentImpl implements _Comment {
  const _$CommentImpl(
      {required this.commentId,
      required this.tgtQuestionId,
      required this.tgtAnswer,
      required this.authId,
      required this.comment,
      required this.likeCount,
      required this.editedFlg,
      required this.deletedFlg,
      required this.rejectedFlg,
      required this.creAt,
      required this.updAt});

  factory _$CommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentImplFromJson(json);

  @override
  final String commentId;
  @override
  final String tgtQuestionId;
  @override
  final int tgtAnswer;
  @override
  final String authId;
  @override
  final String comment;
  @override
  final int likeCount;
  @override
  final bool editedFlg;
  @override
  final bool deletedFlg;
  @override
  final bool rejectedFlg;
  @override
  final DateTime creAt;
  @override
  final DateTime updAt;

  @override
  String toString() {
    return 'Comment(commentId: $commentId, tgtQuestionId: $tgtQuestionId, tgtAnswer: $tgtAnswer, authId: $authId, comment: $comment, likeCount: $likeCount, editedFlg: $editedFlg, deletedFlg: $deletedFlg, rejectedFlg: $rejectedFlg, creAt: $creAt, updAt: $updAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentImpl &&
            (identical(other.commentId, commentId) ||
                other.commentId == commentId) &&
            (identical(other.tgtQuestionId, tgtQuestionId) ||
                other.tgtQuestionId == tgtQuestionId) &&
            (identical(other.tgtAnswer, tgtAnswer) ||
                other.tgtAnswer == tgtAnswer) &&
            (identical(other.authId, authId) || other.authId == authId) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.editedFlg, editedFlg) ||
                other.editedFlg == editedFlg) &&
            (identical(other.deletedFlg, deletedFlg) ||
                other.deletedFlg == deletedFlg) &&
            (identical(other.rejectedFlg, rejectedFlg) ||
                other.rejectedFlg == rejectedFlg) &&
            (identical(other.creAt, creAt) || other.creAt == creAt) &&
            (identical(other.updAt, updAt) || other.updAt == updAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      commentId,
      tgtQuestionId,
      tgtAnswer,
      authId,
      comment,
      likeCount,
      editedFlg,
      deletedFlg,
      rejectedFlg,
      creAt,
      updAt);

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentImplCopyWith<_$CommentImpl> get copyWith =>
      __$$CommentImplCopyWithImpl<_$CommentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentImplToJson(
      this,
    );
  }
}

abstract class _Comment implements Comment {
  const factory _Comment(
      {required final String commentId,
      required final String tgtQuestionId,
      required final int tgtAnswer,
      required final String authId,
      required final String comment,
      required final int likeCount,
      required final bool editedFlg,
      required final bool deletedFlg,
      required final bool rejectedFlg,
      required final DateTime creAt,
      required final DateTime updAt}) = _$CommentImpl;

  factory _Comment.fromJson(Map<String, dynamic> json) = _$CommentImpl.fromJson;

  @override
  String get commentId;
  @override
  String get tgtQuestionId;
  @override
  int get tgtAnswer;
  @override
  String get authId;
  @override
  String get comment;
  @override
  int get likeCount;
  @override
  bool get editedFlg;
  @override
  bool get deletedFlg;
  @override
  bool get rejectedFlg;
  @override
  DateTime get creAt;
  @override
  DateTime get updAt;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentImplCopyWith<_$CommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
