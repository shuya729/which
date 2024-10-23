import 'package:flutter/material.dart';
import 'package:which/models/indexes.dart';
import 'package:which/models/question.dart';
import 'package:which/models/user_data.dart';
import 'package:which/services/saved_service.dart';
import 'package:which/views/created_screen.dart';

class SavedScreen extends CreatedScreen {
  const SavedScreen({super.key});

  @override
  String get title => '保存済み';
  @override
  bool? get allowAnonymous => false;
  static const String absolutePath = '/saved';
  static const String relativePath = 'saved';

  @override
  Future<List<Question?>> initQuestions(
    UserData myData,
    ValueNotifier<List<Question?>> questions,
    ValueNotifier<Indexes> indexes,
  ) async {
    final SavedService savedService = SavedService();
    final List<Question> saveds = await savedService.getSaveds(
      userData: myData,
    );
    questions.value = [...saveds];
    indexes.value = indexes.value.loaded(saveds.length);
    return saveds;
  }

  @override
  Future<List<Question?>> getQuestions(
    UserData myData,
    ValueNotifier<List<Question?>> questions,
    ValueNotifier<Indexes> indexes,
  ) async {
    indexes.value = indexes.value.loading();
    final SavedService savedService = SavedService();
    final List<Question> saveds = await savedService.getSaveds(
      userData: myData,
      last: questions.value.last,
    );
    final List<Question?> preQuestions = questions.value;
    for (Question question in saveds) {
      if (preQuestions.contains(question)) saveds.remove(question);
    }
    questions.value = [...preQuestions, ...saveds];
    indexes.value = indexes.value.loaded(saveds.length);
    return saveds;
  }

  @override
  Future<List<Question?>> refreshQuestions(
    UserData myData,
    ValueNotifier<List<Question?>> questions,
    ValueNotifier<Indexes> indexes,
  ) async {
    final SavedService savedService = SavedService();
    final List<Question> saveds = await savedService.getSaveds(
      userData: myData,
    );
    questions.value = [...saveds];
    indexes.value = Indexes().loaded(saveds.length);
    return saveds;
  }
}
