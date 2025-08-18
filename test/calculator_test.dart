// test/calculator_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz/Calculator.dart';

void main() {
  late Calculator calculator;

  setUp(() {
    calculator = Calculator();
  });

  group('Calculator Tests', () {
    test('Addition works correctly', () {
      expect(calculator.add(3, 2), 5);
    });

    test('Subtraction works correctly', () {
      expect(calculator.subtract(5, 3), 2);
    });

    test('Multiplication works correctly', () {
      expect(calculator.multiply(4, 3), 12);
    });

    test('Division works correctly', () {
      expect(calculator.divide(10, 2), 5);
    });

    test('Division by zero throws error', () {
      expect(() => calculator.divide(5, 0), throwsArgumentError);
    });
  });
}
