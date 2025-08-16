import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../model/score_entry.dart';
import '../../services/score_service.dart';

class ResultsController extends GetxController with GetSingleTickerProviderStateMixin {
  final nameController = TextEditingController();
  final RxBool scoreSaved = false.obs;

  late AnimationController scaleController;
  late Animation<double> scaleAnimation;

  // Arguments from previous screen
  late int score;
  late int totalQuestions;
  String? category;

  @override
  void onInit() {
    super.onInit();

    // Get arguments from navigation
    final args = Get.arguments as Map<String, dynamic>;
    score = args['score'];
    totalQuestions = args['totalQuestions'];
    category = args['category'];

    _initializeAnimations();
  }

  @override
  void onClose() {
    nameController.dispose();
    scaleController.dispose();
    super.onClose();
  }

  void _initializeAnimations() {
    scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: scaleController,
      curve: Curves.elasticOut,
    ));

    scaleController.forward();
  }

  double get percentage => (score / totalQuestions) * 100;

  String get performanceMessage {
    if (percentage >= 90) return "Outstanding! 🏆";
    if (percentage >= 80) return "Excellent! 🌟";
    if (percentage >= 70) return "Great job! 👍";
    if (percentage >= 60) return "Good effort! 📈";
    if (percentage >= 50) return "Keep practicing! 💪";
    return "Don't give up! 🎯";
  }

  Color get scoreColor {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  Future<void> saveScore() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your name',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final scoreEntry = ScoreEntry(
      playerName: nameController.text.trim(),
      score: score,
      totalQuestions: totalQuestions,
      timestamp: DateTime.now(),
      category: category,
    );

    await ScoreService.saveScore(scoreEntry);

    scoreSaved.value = true;

    Get.snackbar(
      'Success',
      'Score saved successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void goToLeaderboard() {
    Get.offAllNamed('/leaderboard');
  }

  void goToHome() {
    Get.offAllNamed('/');
  }

  void tryAgain() {
    Get.toNamed('/quiz', arguments: {'category': category});
  }
}
