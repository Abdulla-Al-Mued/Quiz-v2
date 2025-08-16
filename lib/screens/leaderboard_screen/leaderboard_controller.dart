import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/score_entry.dart';
import '../../services/score_service.dart';

class LeaderboardController extends GetxController {
  final RxList<ScoreEntry> scores = <ScoreEntry>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadScores();
  }

  void loadScores() {
    isLoading.value = true;
    scores.value = ScoreService.getAllScores();
    isLoading.value = false;
  }

  void showClearDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Leaderboard'),
        content: const Text(
          'Are you sure you want to clear all scores? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await ScoreService.clearAllScores();
              loadScores();
              Get.snackbar(
                'Cleared',
                'Leaderboard cleared',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber; // Gold
      case 2:
        return Colors.grey; // Silver
      case 3:
        return Colors.brown; // Bronze
      default:
        return Get.theme.primaryColor;
    }
  }

  IconData getRankIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.emoji_events; // Trophy
      case 2:
        return Icons.military_tech; // Medal
      case 3:
        return Icons.workspace_premium; // Award
      default:
        return Icons.person;
    }
  }

  void goToHome() {
    Get.offAllNamed('/');
  }
}