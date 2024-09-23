// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return _Question.fromJson(json);
}

/// @nodoc
mixin _$Question {
  String get questionId => throw _privateConstructorUsedError;
  String get authId => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError;
  String get answer1 => throw _privateConstructorUsedError;
  String get answer2 => throw _privateConstructorUsedError;
  int get readCOunt => throw _privateConstructorUsedError;
  int get answer1Count => throw _privateConstructorUsedError;
  int get answer2Count => throw _privateConstructorUsedError;
  List<int> get vector => throw _privateConstructorUsedError;
  bool get editedFlg => throw _privateConstructorUsedError;
  bool get hiddenFlg => throw _privateConstructorUsedError;
  bool get deletedFlg => throw _privateConstructorUsedError;
  bool get rejectedFlg => throw _privateConstructorUsedError;
  DateTime get creAt => throw _privateConstructorUsedError;
  DateTime get updAt => throw _privateConstructorUsedError;

  /// Serializes this Question to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionCopyWith<Question> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionCopyWith<$Res> {
  factory $QuestionCopyWith(Question value, $Res Function(Question) then) =
      _$QuestionCopyWithImpl<$Res, Question>;
  @useResult
  $Res call(
      {String questionId,
      String authId,
      String question,
      String answer1,
      String answer2,
      int readCOunt,
      int answer1Count,
      int answer2Count,
      List<int> vector,
      bool editedFlg,
      bool hiddenFlg,
      bool deletedFlg,
      bool rejectedFlg,
      DateTime creAt,
      DateTime updAt});
}

/// @nodoc
class _$QuestionCopyWithImpl<$Res, $Val extends Question>
    implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? authId = null,
    Object? question = null,
    Object? answer1 = null,
    Object? answer2 = null,
    Object? readCOunt = null,
    Object? answer1Count = null,
    Object? answer2Count = null,
    Object? vector = null,
    Object? editedFlg = null,
    Object? hiddenFlg = null,
    Object? deletedFlg = null,
    Object? rejectedFlg = null,
    Object? creAt = null,
    Object? updAt = null,
  }) {
    return _then(_value.copyWith(
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      authId: null == authId
          ? _value.authId
          : authId // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answer1: null == answer1
          ? _value.answer1
          : answer1 // ignore: cast_nullable_to_non_nullable
              as String,
      answer2: null == answer2
          ? _value.answer2
          : answer2 // ignore: cast_nullable_to_non_nullable
              as String,
      readCOunt: null == readCOunt
          ? _value.readCOunt
          : readCOunt // ignore: cast_nullable_to_non_nullable
              as int,
      answer1Count: null == answer1Count
          ? _value.answer1Count
          : answer1Count // ignore: cast_nullable_to_non_nullable
              as int,
      answer2Count: null == answer2Count
          ? _value.answer2Count
          : answer2Count // ignore: cast_nullable_to_non_nullable
              as int,
      vector: null == vector
          ? _value.vector
          : vector // ignore: cast_nullable_to_non_nullable
              as List<int>,
      editedFlg: null == editedFlg
          ? _value.editedFlg
          : editedFlg // ignore: cast_nullable_to_non_nullable
              as bool,
      hiddenFlg: null == hiddenFlg
          ? _value.hiddenFlg
          : hiddenFlg // ignore: cast_nullable_to_non_nullable
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
abstract class _$$QuestionImplCopyWith<$Res>
    implements $QuestionCopyWith<$Res> {
  factory _$$QuestionImplCopyWith(
          _$QuestionImpl value, $Res Function(_$QuestionImpl) then) =
      __$$QuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String questionId,
      String authId,
      String question,
      String answer1,
      String answer2,
      int readCOunt,
      int answer1Count,
      int answer2Count,
      List<int> vector,
      bool editedFlg,
      bool hiddenFlg,
      bool deletedFlg,
      bool rejectedFlg,
      DateTime creAt,
      DateTime updAt});
}

/// @nodoc
class __$$QuestionImplCopyWithImpl<$Res>
    extends _$QuestionCopyWithImpl<$Res, _$QuestionImpl>
    implements _$$QuestionImplCopyWith<$Res> {
  __$$QuestionImplCopyWithImpl(
      _$QuestionImpl _value, $Res Function(_$QuestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? authId = null,
    Object? question = null,
    Object? answer1 = null,
    Object? answer2 = null,
    Object? readCOunt = null,
    Object? answer1Count = null,
    Object? answer2Count = null,
    Object? vector = null,
    Object? editedFlg = null,
    Object? hiddenFlg = null,
    Object? deletedFlg = null,
    Object? rejectedFlg = null,
    Object? creAt = null,
    Object? updAt = null,
  }) {
    return _then(_$QuestionImpl(
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      authId: null == authId
          ? _value.authId
          : authId // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answer1: null == answer1
          ? _value.answer1
          : answer1 // ignore: cast_nullable_to_non_nullable
              as String,
      answer2: null == answer2
          ? _value.answer2
          : answer2 // ignore: cast_nullable_to_non_nullable
              as String,
      readCOunt: null == readCOunt
          ? _value.readCOunt
          : readCOunt // ignore: cast_nullable_to_non_nullable
              as int,
      answer1Count: null == answer1Count
          ? _value.answer1Count
          : answer1Count // ignore: cast_nullable_to_non_nullable
              as int,
      answer2Count: null == answer2Count
          ? _value.answer2Count
          : answer2Count // ignore: cast_nullable_to_non_nullable
              as int,
      vector: null == vector
          ? _value._vector
          : vector // ignore: cast_nullable_to_non_nullable
              as List<int>,
      editedFlg: null == editedFlg
          ? _value.editedFlg
          : editedFlg // ignore: cast_nullable_to_non_nullable
              as bool,
      hiddenFlg: null == hiddenFlg
          ? _value.hiddenFlg
          : hiddenFlg // ignore: cast_nullable_to_non_nullable
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
class _$QuestionImpl implements _Question {
  const _$QuestionImpl(
      {required this.questionId,
      required this.authId,
      required this.question,
      required this.answer1,
      required this.answer2,
      required this.readCOunt,
      required this.answer1Count,
      required this.answer2Count,
      required final List<int> vector,
      required this.editedFlg,
      required this.hiddenFlg,
      required this.deletedFlg,
      required this.rejectedFlg,
      required this.creAt,
      required this.updAt})
      : _vector = vector;

  factory _$QuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionImplFromJson(json);

  @override
  final String questionId;
  @override
  final String authId;
  @override
  final String question;
  @override
  final String answer1;
  @override
  final String answer2;
  @override
  final int readCOunt;
  @override
  final int answer1Count;
  @override
  final int answer2Count;
  final List<int> _vector;
  @override
  List<int> get vector {
    if (_vector is EqualUnmodifiableListView) return _vector;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vector);
  }

  @override
  final bool editedFlg;
  @override
  final bool hiddenFlg;
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
    return 'Question(questionId: $questionId, authId: $authId, question: $question, answer1: $answer1, answer2: $answer2, readCOunt: $readCOunt, answer1Count: $answer1Count, answer2Count: $answer2Count, vector: $vector, editedFlg: $editedFlg, hiddenFlg: $hiddenFlg, deletedFlg: $deletedFlg, rejectedFlg: $rejectedFlg, creAt: $creAt, updAt: $updAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionImpl &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.authId, authId) || other.authId == authId) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.answer1, answer1) || other.answer1 == answer1) &&
            (identical(other.answer2, answer2) || other.answer2 == answer2) &&
            (identical(other.readCOunt, readCOunt) ||
                other.readCOunt == readCOunt) &&
            (identical(other.answer1Count, answer1Count) ||
                other.answer1Count == answer1Count) &&
            (identical(other.answer2Count, answer2Count) ||
                other.answer2Count == answer2Count) &&
            const DeepCollectionEquality().equals(other._vector, _vector) &&
            (identical(other.editedFlg, editedFlg) ||
                other.editedFlg == editedFlg) &&
            (identical(other.hiddenFlg, hiddenFlg) ||
                other.hiddenFlg == hiddenFlg) &&
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
      questionId,
      authId,
      question,
      answer1,
      answer2,
      readCOunt,
      answer1Count,
      answer2Count,
      const DeepCollectionEquality().hash(_vector),
      editedFlg,
      hiddenFlg,
      deletedFlg,
      rejectedFlg,
      creAt,
      updAt);

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      __$$QuestionImplCopyWithImpl<_$QuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionImplToJson(
      this,
    );
  }
}

abstract class _Question implements Question {
  const factory _Question(
      {required final String questionId,
      required final String authId,
      required final String question,
      required final String answer1,
      required final String answer2,
      required final int readCOunt,
      required final int answer1Count,
      required final int answer2Count,
      required final List<int> vector,
      required final bool editedFlg,
      required final bool hiddenFlg,
      required final bool deletedFlg,
      required final bool rejectedFlg,
      required final DateTime creAt,
      required final DateTime updAt}) = _$QuestionImpl;

  factory _Question.fromJson(Map<String, dynamic> json) =
      _$QuestionImpl.fromJson;

  @override
  String get questionId;
  @override
  String get authId;
  @override
  String get question;
  @override
  String get answer1;
  @override
  String get answer2;
  @override
  int get readCOunt;
  @override
  int get answer1Count;
  @override
  int get answer2Count;
  @override
  List<int> get vector;
  @override
  bool get editedFlg;
  @override
  bool get hiddenFlg;
  @override
  bool get deletedFlg;
  @override
  bool get rejectedFlg;
  @override
  DateTime get creAt;
  @override
  DateTime get updAt;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
