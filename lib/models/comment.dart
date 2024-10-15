import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Comment {
  const Comment({
    required this.commentId,
    required this.tgtQuestionId,
    required this.tgtAnswer,
    required this.authId,
    required this.comment,
    required this.likeCount,
    required this.editedFlg,
    required this.deletedFlg,
    required this.rejectedFlg,
    required this.creAt,
    required this.updAt,
  });

  final String commentId;
  final String tgtQuestionId;
  final int tgtAnswer;
  final String authId;
  final String comment;
  final int likeCount;
  final bool editedFlg;
  final bool deletedFlg;
  final bool rejectedFlg;
  final DateTime creAt;
  final DateTime updAt;

  // fromFirestore
  factory Comment.fromFirestore(Map<String, dynamic> data) {
    return Comment(
      commentId: data['commentId'] as String,
      tgtQuestionId: data['tgtQuestionId'] as String,
      tgtAnswer: data['tgtAnswer'] as int,
      authId: data['authId'] as String,
      comment: data['comment'] as String,
      likeCount: data['likeCount'] as int,
      editedFlg: data['editedFlg'] as bool,
      deletedFlg: data['deletedFlg'] as bool,
      rejectedFlg: data['rejectedFlg'] as bool,
      creAt: (data['creAt'] as Timestamp).toDate(),
      updAt: (data['updAt'] as Timestamp).toDate(),
    );
  }

  // toFirestore
  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'commentId': commentId,
      'tgtQuestionId': tgtQuestionId,
      'tgtAnswer': tgtAnswer,
      'authId': authId,
      'comment': comment,
      'likeCount': likeCount,
      'editedFlg': editedFlg,
      'deletedFlg': deletedFlg,
      'rejectedFlg': rejectedFlg,
      'creAt': creAt,
      'updAt': updAt,
    };
  }

  // copyWith
  Comment copyWith({
    String? commentId,
    String? tgtQuestionId,
    int? tgtAnswer,
    String? authId,
    String? comment,
    int? likeCount,
    bool? editedFlg,
    bool? deletedFlg,
    bool? rejectedFlg,
    DateTime? creAt,
    DateTime? updAt,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      tgtQuestionId: tgtQuestionId ?? this.tgtQuestionId,
      tgtAnswer: tgtAnswer ?? this.tgtAnswer,
      authId: authId ?? this.authId,
      comment: comment ?? this.comment,
      likeCount: likeCount ?? this.likeCount,
      editedFlg: editedFlg ?? this.editedFlg,
      deletedFlg: deletedFlg ?? this.deletedFlg,
      rejectedFlg: rejectedFlg ?? this.rejectedFlg,
      creAt: creAt ?? this.creAt,
      updAt: updAt ?? this.updAt,
    );
  }

  // hashCode
  @override
  int get hashCode =>
      commentId.hashCode ^
      tgtQuestionId.hashCode ^
      tgtAnswer.hashCode ^
      authId.hashCode ^
      comment.hashCode ^
      likeCount.hashCode ^
      editedFlg.hashCode ^
      deletedFlg.hashCode ^
      rejectedFlg.hashCode ^
      creAt.hashCode ^
      updAt.hashCode;

  // operator ==
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Comment otherComment = other as Comment;
    return commentId == otherComment.commentId &&
        tgtQuestionId == otherComment.tgtQuestionId &&
        tgtAnswer == otherComment.tgtAnswer &&
        authId == otherComment.authId &&
        comment == otherComment.comment &&
        likeCount == otherComment.likeCount &&
        editedFlg == otherComment.editedFlg &&
        deletedFlg == otherComment.deletedFlg &&
        rejectedFlg == otherComment.rejectedFlg &&
        creAt == otherComment.creAt &&
        updAt == otherComment.updAt;
  }
}
