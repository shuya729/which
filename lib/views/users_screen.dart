import 'package:flutter/material.dart';
import 'package:which/models/indexes.dart';
import 'package:which/models/question.dart';
import 'package:which/models/user_data.dart';
import 'package:which/services/question_service.dart';
import 'package:which/services/user_service.dart';
import 'package:which/views/created_screen.dart';

class UsersScreen extends CreatedScreen {
  const UsersScreen({super.key, required this.authId});

  final String authId;

  @override
  String get title => 'ユーザー';
  @override
  bool? get allowAnonymous => null;
  static String absolutePath(String authId) => '/users/$authId';
  static const String relativePath = 'users/:authId';

  @override
  Future<List<Question?>> initQuestions(
    ValueNotifier<UserData> userData,
    ValueNotifier<List<Question?>> questions,
    ValueNotifier<Indexes> indexes,
  ) async {
    final UserData? tgtUser = await UserService().get(authId);
    if (tgtUser == null) return [];
    userData.value = tgtUser;
    final QuestionService questionService = QuestionService();
    final List<Question> createds = await questionService.getCreateds(
      userData: tgtUser,
    );
    questions.value = [...createds];
    indexes.value = indexes.value.loaded(createds.length);
    return createds;
  }
}
