import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/Question.dart';
import '../../services/quiz_services.dart';

class QuizController extends GetxController with GetTickerProviderStateMixin {
  // Observable variables
  final RxList<Question> questions = <Question>[].obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxInt score = 0.obs;
  final RxnInt selectedAnswerIndex = RxnInt();
  final RxBool showAnswer = false.obs;
  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();
  final RxInt timeLeft = 0.obs;

  // Configuration
  final String? category;
  final int questionCount;
  final int timePerQuestion;

  // Animation controllers
  late AnimationController progressController;
  late AnimationController slideController;
  late Animation<Offset> slideAnimation;

  Timer? _timer;

  QuizController({
    this.category,
    this.questionCount = 10,
    this.timePerQuestion = 15,
  });

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    loadQuestions();
  }

  @override
  void onClose() {
    _timer?.cancel();
    progressController.dispose();
    slideController.dispose();
    super.onClose();
  }

  void _initializeAnimations() {
    progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: slideController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> loadQuestions() async {
    try {
      isLoading.value = true;
      final allQuestions = await QuizService.loadQuestions();

      List<Question> filteredQuestions = allQuestions;
      if (category != null) {
        filteredQuestions = QuizService.getQuestionsByCategory(
          allQuestions,
          category!,
        );
      }

      if (filteredQuestions.isEmpty) {
        throw Exception('No questions found for selected criteria');
      }

      questions.value = QuizService.getRandomQuestions(
        filteredQuestions,
        questionCount,
      );

      isLoading.value = false;
      _startTimer();
      slideController.forward();
      _updateProgress();
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
    }
  }

  void _startTimer() {
    timeLeft.value = timePerQuestion;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeLeft.value--;

      if (timeLeft.value <= 0) {
        _timer?.cancel();
        if (!showAnswer.value) {
          _handleTimeUp();
        }
      }
    });
  }

  void _handleTimeUp() {
    showAnswer.value = true;

    Future.delayed(const Duration(seconds: 1), () {
      nextQuestion();
    });
  }

  void _updateProgress() {
    progressController.animateTo(
      (currentQuestionIndex.value + 1) / questions.length,
    );
  }

  void selectAnswer(int index) {
    if (selectedAnswerIndex.value != null || showAnswer.value) return;

    selectedAnswerIndex.value = index;
    showAnswer.value = true;

    _timer?.cancel();

    // Check if answer is correct
    if (index == questions[currentQuestionIndex.value].correctAnswerIndex) {
      score.value++;
    }

    // Wait before moving to next question
    Future.delayed(const Duration(seconds: 2), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      selectedAnswerIndex.value = null;
      showAnswer.value = false;

      slideController.reset();
      slideController.forward();
      _updateProgress();
      _startTimer();
    } else {
      finishQuiz();
    }
  }

  void finishQuiz() {
    _timer?.cancel();
    Get.offNamed('/results', arguments: {
      'score': score.value,
      'totalQuestions': questions.length,
      'category': category,
    });
  }

  Color getAnswerColor(int index) {
    if (!showAnswer.value) {
      return selectedAnswerIndex.value == index
          ? Get.theme.primaryColor.withOpacity(0.3)
          : Colors.transparent;
    }

    final correctIndex = questions[currentQuestionIndex.value].correctAnswerIndex;

    if (index == correctIndex) {
      return Colors.green.withOpacity(0.3);
    } else if (index == selectedAnswerIndex.value && index != correctIndex) {
      return Colors.red.withOpacity(0.3);
    }

    return Colors.transparent;
  }
}