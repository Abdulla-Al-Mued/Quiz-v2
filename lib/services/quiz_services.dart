import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

import '../model/Question.dart';

class QuizService {
  static List<Question>? _cachedQuestions;

  static Future<List<Question>> loadQuestions() async {
    if (_cachedQuestions != null) {
      return _cachedQuestions!;
    }

    try {
      final String data = await rootBundle.loadString('assets/questions.json');
      final Map<String, dynamic> jsonData = json.decode(data);
      final List<dynamic> questionsJson = jsonData['questions'];

      _cachedQuestions = questionsJson
          .map((json) => Question.fromJson(json))
          .toList();

      return _cachedQuestions!;
    } catch (e) {
      throw Exception('Failed to load questions: $e');
    }
  }

  static List<Question> getRandomQuestions(List<Question> questions, int count) {
    final random = Random();
    final shuffled = List<Question>.from(questions)..shuffle(random);
    return shuffled.take(count).toList();
  }

  static List<Question> getQuestionsByCategory(
      List<Question> questions, String category) {
    return questions
        .where((q) => q.category?.toLowerCase() == category.toLowerCase())
        .toList();
  }

  static Set<String> getCategories(List<Question> questions) {
    return questions
        .where((q) => q.category != null)
        .map((q) => q.category!)
        .toSet();
  }
}