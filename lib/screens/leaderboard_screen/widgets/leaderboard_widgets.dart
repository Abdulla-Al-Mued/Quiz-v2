import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/score_service.dart';
import '../leaderboard_controller.dart';

Widget buildModernStatsHeader(LeaderboardController controller) {
  final bestScore = ScoreService.getBestScore();
  final averageScore = ScoreService.getAverageScore();

  return Container(
    margin: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Title
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.analytics_rounded,
                  color: Get.theme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Performance Overview',
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Get.theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),

        // Stats Cards
        Row(
          children: [
            Expanded(
              child: _buildModernStatCard(
                'Total Players',
                controller.scores.length.toString(),
                Icons.people_rounded,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildModernStatCard(
                'Best Score',
                bestScore != null
                    ? '${bestScore.score}/${bestScore.totalQuestions}'
                    : 'N/A',
                Icons.star_rounded,
                Colors.amber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildModernStatCard(
                'Average',
                '${averageScore.toStringAsFixed(1)}%',
                Icons.trending_up_rounded,
                Colors.green,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildModernStatCard(String label, String value, IconData icon, Color accentColor) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Get.theme.brightness == Brightness.dark
          ? Colors.grey[850]
          : Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Get.theme.brightness == Brightness.dark
            ? Colors.grey[700]!
            : Colors.grey[200]!,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Get.theme.brightness == Brightness.dark
              ? Colors.black.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: accentColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: Get.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: Get.theme.brightness == Brightness.dark
                ? Colors.white
                : Colors.grey[800],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Get.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget buildLeaderboardItem(LeaderboardController controller, score, int rank) {
  final percentage = score.percentage;
  final isTopThree = rank <= 3;

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: isTopThree
          ? Border.all(color: controller.getRankColor(rank), width: 1)
          : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: controller.getRankColor(rank).withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: controller.getRankColor(rank), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              controller.getRankIcon(rank),
              color: controller.getRankColor(rank),
              size: isTopThree ? 20 : 16,
            ),
            if (!isTopThree)
              Text(
                rank.toString(),
                style: TextStyle(
                  color: controller.getRankColor(rank),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
      title: Text(
        score.playerName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: isTopThree ? 16 : 14,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.formatDate(score.timestamp),
            style: Get.textTheme.bodySmall,
          ),
          if (score.category != null)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Get.theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                score.category!,
                style: TextStyle(
                  color: Get.theme.primaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${score.score}/${score.totalQuestions}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTopThree ? 18 : 16,
              color: percentage >= 80
                  ? Colors.green
                  : percentage >= 60
                  ? Colors.orange
                  : Colors.red,
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: Get.textTheme.bodySmall?.copyWith(
              color: percentage >= 80
                  ? Colors.green
                  : percentage >= 60
                  ? Colors.orange
                  : Colors.red,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildEmptyState(LeaderboardController controller) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.leaderboard_outlined,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No scores yet!',
            style: Get.textTheme.headlineSmall?.copyWith(
              color: Colors.grey.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Take a quiz to see your score on the leaderboard',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.goToHome,
            icon: const Icon(Icons.quiz),
            label: const Text('Take a Quiz'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}