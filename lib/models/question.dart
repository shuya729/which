import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Question {
  const Question({
    required this.questionId,
    required this.authId,
    required this.quest,
    required this.answer1,
    required this.answer2,
    required this.readCount,
    required this.answer1Count,
    required this.answer2Count,
    // required this.vector,
    required this.editedFlg,
    required this.hiddenFlg,
    required this.deletedFlg,
    required this.rejectedFlg,
    required this.creAt,
    required this.updAt,
  });

  final String questionId;
  final String authId;
  final String quest;
  final String answer1;
  final String answer2;
  final int readCount;
  final int answer1Count;
  final int answer2Count;
  // final List<double> vector;
  final bool editedFlg;
  final bool hiddenFlg;
  final bool deletedFlg;
  final bool rejectedFlg;
  final DateTime creAt;
  final DateTime updAt;

  factory Question.crate({
    required String authId,
    required String quest,
    required String answer1,
    required String answer2,
  }) {
    return Question(
      questionId: '',
      authId: authId,
      quest: quest,
      answer1: answer1,
      answer2: answer2,
      readCount: 0,
      answer1Count: 0,
      answer2Count: 0,
      // vector: const [],
      editedFlg: false,
      hiddenFlg: false,
      deletedFlg: false,
      rejectedFlg: false,
      creAt: DateTime.now(),
      updAt: DateTime.now(),
    );
  }

  // fromMap(fromJson)
  factory Question.fromMap(Map<String, dynamic> data) {
    return Question(
      questionId: data['questionId'] as String,
      authId: data['authId'] as String,
      quest: data['quest'] as String,
      answer1: data['answer1'] as String,
      answer2: data['answer2'] as String,
      readCount: data['readCount'] as int,
      answer1Count: data['answer1Count'] as int,
      answer2Count: data['answer2Count'] as int,
      editedFlg: data['editedFlg'] as bool,
      hiddenFlg: data['hiddenFlg'] as bool,
      deletedFlg: data['deletedFlg'] as bool,
      rejectedFlg: data['rejectedFlg'] as bool,
      creAt: DateTime.fromMillisecondsSinceEpoch(
        ((data['creAt'] as Map)['_seconds']) * 1000,
      ),
      updAt: DateTime.fromMillisecondsSinceEpoch(
        ((data['updAt'] as Map)['_seconds']) * 1000,
      ),
    );
  }

  // fromFirestore
  factory Question.fromFirestore(Map<String, dynamic> data) {
    return Question(
      questionId: data['questionId'] as String,
      authId: data['authId'] as String,
      quest: data['quest'] as String,
      answer1: data['answer1'] as String,
      answer2: data['answer2'] as String,
      readCount: data['readCount'] as int,
      answer1Count: data['answer1Count'] as int,
      answer2Count: data['answer2Count'] as int,
      // vector: (data['vector'] as List).map((e) => e as double).toList(),
      editedFlg: data['editedFlg'] as bool,
      hiddenFlg: data['hiddenFlg'] as bool,
      deletedFlg: data['deletedFlg'] as bool,
      rejectedFlg: data['rejectedFlg'] as bool,
      creAt: (data['creAt'] as Timestamp).toDate(),
      updAt: (data['updAt'] as Timestamp).toDate(),
    );
  }

  // toFirestore
  Map<String, dynamic> toFirestore({
    bool incrementRead = false,
    bool incrementAnswer1 = false,
    bool incrementAnswer2 = false,
  }) {
    return <String, dynamic>{
      'questionId': questionId,
      'authId': authId,
      'quest': quest,
      'answer1': answer1,
      'answer2': answer2,
      'readCount': incrementRead ? FieldValue.increment(1) : readCount,
      'answer1Count': incrementAnswer1 ? FieldValue.increment(1) : answer1Count,
      'answer2Count': incrementAnswer2 ? FieldValue.increment(1) : answer2Count,
      // 'vector': vector,
      'editedFlg': editedFlg,
      'hiddenFlg': hiddenFlg,
      'deletedFlg': deletedFlg,
      'rejectedFlg': rejectedFlg,
      'creAt': creAt,
      'updAt': updAt,
    };
  }

  // copyWith
  Question copyWith({
    String? questionId,
    String? authId,
    String? quest,
    String? answer1,
    String? answer2,
    int? readCount,
    int? answer1Count,
    int? answer2Count,
    // List<double>? vector,
    bool? editedFlg,
    bool? hiddenFlg,
    bool? deletedFlg,
    bool? rejectedFlg,
    DateTime? creAt,
    DateTime? updAt,
  }) {
    return Question(
      questionId: questionId ?? this.questionId,
      authId: authId ?? this.authId,
      quest: quest ?? this.quest,
      answer1: answer1 ?? this.answer1,
      answer2: answer2 ?? this.answer2,
      readCount: readCount ?? this.readCount,
      answer1Count: answer1Count ?? this.answer1Count,
      answer2Count: answer2Count ?? this.answer2Count,
      // vector: vector ?? this.vector,
      editedFlg: editedFlg ?? this.editedFlg,
      hiddenFlg: hiddenFlg ?? this.hiddenFlg,
      deletedFlg: deletedFlg ?? this.deletedFlg,
      rejectedFlg: rejectedFlg ?? this.rejectedFlg,
      creAt: creAt ?? this.creAt,
      updAt: updAt ?? this.updAt,
    );
  }

  // hashCode
  @override
  int get hashCode =>
      questionId.hashCode ^
      authId.hashCode ^
      quest.hashCode ^
      answer1.hashCode ^
      answer2.hashCode ^
      readCount.hashCode ^
      answer1Count.hashCode ^
      answer2Count.hashCode ^
      // vector.hashCode ^
      editedFlg.hashCode ^
      hiddenFlg.hashCode ^
      deletedFlg.hashCode ^
      rejectedFlg.hashCode ^
      creAt.hashCode ^
      updAt.hashCode;

  // operator ==
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Question otherQuestion = other as Question;
    return questionId == otherQuestion.questionId &&
        authId == otherQuestion.authId &&
        quest == otherQuestion.quest &&
        answer1 == otherQuestion.answer1 &&
        answer2 == otherQuestion.answer2 &&
        readCount == otherQuestion.readCount &&
        answer1Count == otherQuestion.answer1Count &&
        answer2Count == otherQuestion.answer2Count &&
        // vector == otherQuestion.vector &&
        editedFlg == otherQuestion.editedFlg &&
        hiddenFlg == otherQuestion.hiddenFlg &&
        deletedFlg == otherQuestion.deletedFlg &&
        rejectedFlg == otherQuestion.rejectedFlg &&
        creAt == otherQuestion.creAt &&
        updAt == otherQuestion.updAt;
  }
}
