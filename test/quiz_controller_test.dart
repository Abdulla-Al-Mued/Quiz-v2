import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz/model/Question.dart';
import 'package:quiz/screens/quiz/QuizController.dart';


class TestVSync implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuizController Score Counting', () {
    late QuizController controller;

    setUp(() {
      controller = QuizController();
      controller.progressController = AnimationController(
        vsync: TestVSync(),
        duration: const Duration(milliseconds: 300),
      );
      controller.slideController = AnimationController(
        vsync: TestVSync(),
        duration: const Duration(milliseconds: 300),
      );

      controller.questions.value = [
        Question(
          question: 'What is 2 + 2?',
          options: ['3', '4', '5', '6'],
          correctAnswerIndex: 1,
        ),
        Question(
          question: 'What is 3 + 5?',
          options: ['5', '7', '8', '9'],
          correctAnswerIndex: 2,
        ),
      ];
    });


    test('Initial score should be 0', () {
      expect(controller.score.value, 0);
    });

    test('Correct answer increases score', () async {
      controller.selectAnswer(1); // Correct answer for Q1
      expect(controller.score.value, 1);
    });

    test('Wrong answer does not increase score', () async {
      controller.selectAnswer(0); // Wrong answer for Q1
      expect(controller.score.value, 0);
    });

    test('Score accumulates over multiple questions', () async {
      controller.selectAnswer(1); // Q1 correct
      controller.nextQuestion();

      controller.selectAnswer(2); // Q2 correct
      expect(controller.score.value, 2);
    });
  });
}
