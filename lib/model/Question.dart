class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? category;
  final String? explanation;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.category,
    this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswerIndex: json['correctAnswerIndex'] as int,
      category: json['category'] as String?,
      explanation: json['explanation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'category': category,
      'explanation': explanation,
    };
  }
}