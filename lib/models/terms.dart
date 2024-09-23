import 'package:freezed_annotation/freezed_annotation.dart';

part 'terms.freezed.dart';
part 'terms.g.dart';

@freezed
class Terms with _$Terms {
  const factory Terms({
    required String type,
    required String text,
    required int indent,
  }) = _Terms;

  factory Terms.fromJson(Map<String, dynamic> json) => _$TermsFromJson(json);
}
