// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'color_set.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ColorSet {
  Color get leftColor => throw _privateConstructorUsedError;
  Color get rightColor => throw _privateConstructorUsedError;

  /// Create a copy of ColorSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ColorSetCopyWith<ColorSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ColorSetCopyWith<$Res> {
  factory $ColorSetCopyWith(ColorSet value, $Res Function(ColorSet) then) =
      _$ColorSetCopyWithImpl<$Res, ColorSet>;
  @useResult
  $Res call({Color leftColor, Color rightColor});
}

/// @nodoc
class _$ColorSetCopyWithImpl<$Res, $Val extends ColorSet>
    implements $ColorSetCopyWith<$Res> {
  _$ColorSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ColorSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leftColor = null,
    Object? rightColor = null,
  }) {
    return _then(_value.copyWith(
      leftColor: null == leftColor
          ? _value.leftColor
          : leftColor // ignore: cast_nullable_to_non_nullable
              as Color,
      rightColor: null == rightColor
          ? _value.rightColor
          : rightColor // ignore: cast_nullable_to_non_nullable
              as Color,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ColorSetImplCopyWith<$Res>
    implements $ColorSetCopyWith<$Res> {
  factory _$$ColorSetImplCopyWith(
          _$ColorSetImpl value, $Res Function(_$ColorSetImpl) then) =
      __$$ColorSetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Color leftColor, Color rightColor});
}

/// @nodoc
class __$$ColorSetImplCopyWithImpl<$Res>
    extends _$ColorSetCopyWithImpl<$Res, _$ColorSetImpl>
    implements _$$ColorSetImplCopyWith<$Res> {
  __$$ColorSetImplCopyWithImpl(
      _$ColorSetImpl _value, $Res Function(_$ColorSetImpl) _then)
      : super(_value, _then);

  /// Create a copy of ColorSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leftColor = null,
    Object? rightColor = null,
  }) {
    return _then(_$ColorSetImpl(
      leftColor: null == leftColor
          ? _value.leftColor
          : leftColor // ignore: cast_nullable_to_non_nullable
              as Color,
      rightColor: null == rightColor
          ? _value.rightColor
          : rightColor // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc

class _$ColorSetImpl implements _ColorSet {
  const _$ColorSetImpl({required this.leftColor, required this.rightColor});

  @override
  final Color leftColor;
  @override
  final Color rightColor;

  @override
  String toString() {
    return 'ColorSet(leftColor: $leftColor, rightColor: $rightColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ColorSetImpl &&
            (identical(other.leftColor, leftColor) ||
                other.leftColor == leftColor) &&
            (identical(other.rightColor, rightColor) ||
                other.rightColor == rightColor));
  }

  @override
  int get hashCode => Object.hash(runtimeType, leftColor, rightColor);

  /// Create a copy of ColorSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ColorSetImplCopyWith<_$ColorSetImpl> get copyWith =>
      __$$ColorSetImplCopyWithImpl<_$ColorSetImpl>(this, _$identity);
}

abstract class _ColorSet implements ColorSet {
  const factory _ColorSet(
      {required final Color leftColor,
      required final Color rightColor}) = _$ColorSetImpl;

  @override
  Color get leftColor;
  @override
  Color get rightColor;

  /// Create a copy of ColorSet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ColorSetImplCopyWith<_$ColorSetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
