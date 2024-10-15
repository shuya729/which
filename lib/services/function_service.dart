import 'package:cloud_functions/cloud_functions.dart';
import 'package:which/models/question.dart';

class FunctionService {
  final FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: 'asia-northeast1');

  Future<List<Question>> getQuestions() async {
    final HttpsCallable callable = _functions.httpsCallable('getQuestions');
    final HttpsCallableResult result = await callable.call();
    final List<dynamic> list = result.data as List<dynamic>;
    final List<Question> questions = [];
    for (final map in list) {
      if (map is Map<dynamic, dynamic>) {
        final data = map.cast<String, dynamic>();
        questions.add(Question.fromMap(data));
      }
    }
    return questions;
  }

  Future<List<Question>> initQuestions({String? questionId}) async {
    final HttpsCallable callable = _functions.httpsCallable('initQuestions');
    final HttpsCallableResult result =
        await callable.call({'questionId': questionId});
    final List<dynamic> list = result.data as List<dynamic>;
    final List<Question> questions = [];
    for (final map in list) {
      if (map is Map<dynamic, dynamic>) {
        final data = map.cast<String, dynamic>();
        questions.add(Question.fromMap(data));
      }
    }
    return questions;
  }

  Future<List<Question>> searchQuestions({required String input}) async {
    final HttpsCallable callable = _functions.httpsCallable('searchQuestions');
    final HttpsCallableResult result = await callable.call({'input': input});
    final List<dynamic> list = result.data as List<dynamic>;
    final List<Question> questions = [];
    for (final map in list) {
      if (map is Map<dynamic, dynamic>) {
        final data = map.cast<String, dynamic>();
        questions.add(Question.fromMap(data));
      }
    }
    return questions;
  }
}
