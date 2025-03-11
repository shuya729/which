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
    required this.editedFlg,
    required this.hiddenFlg,
    required this.deletedFlg,
    required this.rejectedFlg,
    required this.creAt,
    required this.updAt,
    required this.lastAt,
  });

  final String questionId;
  final String authId;
  final String quest;
  final String answer1;
  final String answer2;
  final bool editedFlg;
  final bool hiddenFlg;
  final bool deletedFlg;
  final bool rejectedFlg;
  final DateTime creAt;
  final DateTime updAt;
  final DateTime lastAt; // savedのcreAtを保持するため

  static Map<String, dynamic> forSet(
    String questionId,
    String authId,
    String quest,
    String answer1,
    String answer2,
  ) {
    return <String, dynamic>{
      'questionId': questionId,
      'authId': authId,
      'quest': quest,
      'answer1': answer1,
      'answer2': answer2,
      'editedFlg': false,
      'hiddenFlg': false,
      'deletedFlg': false,
      'rejectedFlg': false,
      'creAt': FieldValue.serverTimestamp(),
      'updAt': FieldValue.serverTimestamp(),
    };
  }

  // fromMap(fromJson)
  factory Question.fromMap(Map<String, dynamic> data) {
    return Question(
      questionId: data['questionId'] as String? ?? '',
      authId: data['authId'] as String? ?? '',
      quest: data['quest'] as String? ?? '',
      answer1: data['answer1'] as String? ?? '',
      answer2: data['answer2'] as String? ?? '',
      editedFlg: data['editedFlg'] as bool? ?? false,
      hiddenFlg: data['hiddenFlg'] as bool? ?? false,
      deletedFlg: data['deletedFlg'] as bool? ?? false,
      rejectedFlg: data['rejectedFlg'] as bool? ?? false,
      creAt: DateTime.fromMillisecondsSinceEpoch(
        ((data['creAt'] as Map?)?['_seconds'] as num?)?.toInt() ?? 0 * 1000,
      ),
      updAt: DateTime.fromMillisecondsSinceEpoch(
        ((data['updAt'] as Map?)?['_seconds'] as num?)?.toInt() ?? 0 * 1000,
      ),
      lastAt: DateTime.fromMillisecondsSinceEpoch(
        ((data['creAt'] as Map?)?['_seconds'] as num?)?.toInt() ?? 0 * 1000,
      ),
    );
  }

  // fromFirestore
  factory Question.fromFirestore(Map<String, dynamic> data) {
    return Question(
      questionId: data['questionId'] as String? ?? '',
      authId: data['authId'] as String? ?? '',
      quest: data['quest'] as String? ?? '',
      answer1: data['answer1'] as String? ?? '',
      answer2: data['answer2'] as String? ?? '',
      editedFlg: data['editedFlg'] as bool? ?? false,
      hiddenFlg: data['hiddenFlg'] as bool? ?? false,
      deletedFlg: data['deletedFlg'] as bool? ?? false,
      rejectedFlg: data['rejectedFlg'] as bool? ?? false,
      creAt: (data['creAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updAt: (data['updAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastAt: (data['creAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // copyWith
  Question copyWith({
    String? questionId,
    String? authId,
    String? quest,
    String? answer1,
    String? answer2,
    bool? editedFlg,
    bool? hiddenFlg,
    bool? deletedFlg,
    bool? rejectedFlg,
    DateTime? creAt,
    DateTime? updAt,
    DateTime? lastAt,
  }) {
    return Question(
      questionId: questionId ?? this.questionId,
      authId: authId ?? this.authId,
      quest: quest ?? this.quest,
      answer1: answer1 ?? this.answer1,
      answer2: answer2 ?? this.answer2,
      editedFlg: editedFlg ?? this.editedFlg,
      hiddenFlg: hiddenFlg ?? this.hiddenFlg,
      deletedFlg: deletedFlg ?? this.deletedFlg,
      rejectedFlg: rejectedFlg ?? this.rejectedFlg,
      creAt: creAt ?? this.creAt,
      updAt: updAt ?? this.updAt,
      lastAt: lastAt ?? this.lastAt,
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
      editedFlg.hashCode ^
      hiddenFlg.hashCode ^
      deletedFlg.hashCode ^
      rejectedFlg.hashCode ^
      creAt.hashCode ^
      updAt.hashCode ^
      lastAt.hashCode;

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
        editedFlg == otherQuestion.editedFlg &&
        hiddenFlg == otherQuestion.hiddenFlg &&
        deletedFlg == otherQuestion.deletedFlg &&
        rejectedFlg == otherQuestion.rejectedFlg &&
        creAt == otherQuestion.creAt &&
        updAt == otherQuestion.updAt &&
        lastAt == otherQuestion.lastAt;
  }
}
