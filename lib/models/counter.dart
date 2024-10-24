import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:which/models/question.dart';

@immutable
class Counter {
  static const int shardsNum = 10;
  final String questionId;
  final int readed;
  final int watched;
  final int answer1;
  final int answer2;

  const Counter({
    required this.questionId,
    required this.readed,
    required this.watched,
    required this.answer1,
    required this.answer2,
  });

  static Map<String, dynamic> forIncrement(
    Question question, {
    bool incrementRead = false,
    bool incrementWatch = false,
    bool incrementAnswer1 = false,
    bool incrementAnswer2 = false,
  }) {
    final Map<String, dynamic> data = {'questionId': question.questionId};
    if (incrementRead) data['readed'] = FieldValue.increment(1);
    if (incrementWatch) data['watched'] = FieldValue.increment(1);
    if (incrementAnswer1) data['answer1'] = FieldValue.increment(1);
    if (incrementAnswer2) data['answer2'] = FieldValue.increment(1);
    return data;
  }

  factory Counter.fromDocs(List<DocumentSnapshot> docs) {
    String questionId = '';
    int readed = 0;
    int watched = 0;
    int answer1 = 0;
    int answer2 = 0;
    for (final DocumentSnapshot doc in docs) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      questionId = data['questionId'] as String? ?? '';
      readed += data['readed'] as int? ?? 0;
      watched += data['watched'] as int? ?? 0;
      answer1 += data['answer1'] as int? ?? 0;
      answer2 += data['answer2'] as int? ?? 0;
    }
    return Counter(
      questionId: questionId,
      readed: readed,
      watched: watched,
      answer1: answer1,
      answer2: answer2,
    );
  }

  // copyWith
  Counter copyWith({
    String? questionId,
    int? readed,
    int? watched,
    int? answer1,
    int? answer2,
  }) {
    return Counter(
      questionId: questionId ?? this.questionId,
      readed: readed ?? this.readed,
      watched: watched ?? this.watched,
      answer1: answer1 ?? this.answer1,
      answer2: answer2 ?? this.answer2,
    );
  }

  // hashCode
  @override
  int get hashCode =>
      questionId.hashCode ^
      readed.hashCode ^
      watched.hashCode ^
      answer1.hashCode ^
      answer2.hashCode;

  // ==
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Counter &&
          runtimeType == other.runtimeType &&
          questionId == other.questionId &&
          readed == other.readed &&
          watched == other.watched &&
          answer1 == other.answer1 &&
          answer2 == other.answer2;
}
