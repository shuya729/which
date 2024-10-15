// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// @immutable
// class Answer {
//   const Answer({
//     required this.authId,
//     required this.tgtQuestionId,
//     required this.tgtAnswer,
//     required this.likeCount,
//     required this.creAt,
//   });

//   final String authId;
//   final String tgtQuestionId;
//   final String tgtAnswer;
//   final int likeCount;
//   final DateTime creAt;

//   // fromFirestore
//   factory Answer.fromFirestore(Map<String, dynamic> data) {
//     return Answer(
//       authId: data['authId'] as String,
//       tgtQuestionId: data['tgtQuestionId'] as String,
//       tgtAnswer: data['tgtAnswer'] as String,
//       likeCount: data['likeCount'] as int,
//       creAt: (data['creAt'] as Timestamp).toDate(),
//     );
//   }

//   // toFirestore
//   Map<String, dynamic> toFirestore() {
//     return <String, dynamic>{
//       'authId': authId,
//       'tgtQuestionId': tgtQuestionId,
//       'tgtAnswer': tgtAnswer,
//       'likeCount': likeCount,
//       'creAt': creAt,
//     };
//   }

//   // copyWith
//   Answer copyWith({
//     String? authId,
//     String? tgtQuestionId,
//     String? tgtAnswer,
//     int? likeCount,
//     DateTime? creAt,
//   }) {
//     return Answer(
//       authId: authId ?? this.authId,
//       tgtQuestionId: tgtQuestionId ?? this.tgtQuestionId,
//       tgtAnswer: tgtAnswer ?? this.tgtAnswer,
//       likeCount: likeCount ?? this.likeCount,
//       creAt: creAt ?? this.creAt,
//     );
//   }

//   // hashCode
//   @override
//   int get hashCode =>
//       authId.hashCode ^
//       tgtQuestionId.hashCode ^
//       tgtAnswer.hashCode ^
//       likeCount.hashCode ^
//       creAt.hashCode;

//   // operator ==
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     if (other.runtimeType != runtimeType) return false;
//     final Answer otherAnswer = other as Answer;
//     return authId == otherAnswer.authId &&
//         tgtQuestionId == otherAnswer.tgtQuestionId &&
//         tgtAnswer == otherAnswer.tgtAnswer &&
//         likeCount == otherAnswer.likeCount &&
//         creAt == otherAnswer.creAt;
//   }
// }
