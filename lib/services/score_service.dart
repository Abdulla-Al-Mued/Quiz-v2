import 'package:hive/hive.dart';

import '../model/score_entry.dart';

class ScoreService {
  static const String _boxName = 'scores';

  static Box<ScoreEntry> get _box => Hive.box<ScoreEntry>(_boxName);

  static Future<void> saveScore(ScoreEntry score) async {
    await _box.add(score);
  }

  static List<ScoreEntry> getAllScores() {
    return _box.values.toList()
      ..sort((a, b) {
        // Sort by score descending, then by percentage, then by timestamp
        int scoreComparison = b.score.compareTo(a.score);
        if (scoreComparison != 0) return scoreComparison;

        int percentageComparison = b.percentage.compareTo(a.percentage);
        if (percentageComparison != 0) return percentageComparison;

        return b.timestamp.compareTo(a.timestamp);
      });
  }

  static List<ScoreEntry> getTopScores(int limit) {
    final allScores = getAllScores();
    return allScores.take(limit).toList();
  }

  static Future<void> clearAllScores() async {
    await _box.clear();
  }

  static double getAverageScore() {
    final scores = getAllScores();
    if (scores.isEmpty) return 0.0;

    final totalPercentage = scores.fold<double>(
        0.0, (sum, score) => sum + score.percentage);
    return totalPercentage / scores.length;
  }

  static ScoreEntry? getBestScore() {
    final scores = getAllScores();
    return scores.isEmpty ? null : scores.first;
  }
}