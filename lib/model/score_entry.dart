import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class ScoreEntry extends HiveObject {
  @HiveField(0)
  String playerName;

  @HiveField(1)
  int score;

  @HiveField(2)
  int totalQuestions;

  @HiveField(3)
  DateTime timestamp;

  @HiveField(4)
  String? category;

  ScoreEntry({
    required this.playerName,
    required this.score,
    required this.totalQuestions,
    required this.timestamp,
    this.category,
  });

  double get percentage => (score / totalQuestions) * 100;
}