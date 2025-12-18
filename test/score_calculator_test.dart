import 'package:flutter_test/flutter_test.dart';
import 'package:puntajepro/domain/models/attempt.dart';
import 'package:puntajepro/domain/models/question.dart';
import 'package:puntajepro/domain/usecases/score_calculator.dart';

void main() {
  test('ScoreCalculator builds area accuracy', () {
    const question = Question(
      id: 'q1',
      area: 'Matemáticas',
      topic: 'Álgebra',
      statement: 'x?',
      options: ['a', 'b', 'c', 'd'],
      answerIndex: 0,
      explanation: 'demo',
    );

    final attempts = [
      Attempt.evaluate(question, 0),
      Attempt.evaluate(question, 1),
    ];

    final progress = ScoreCalculator().buildProgress(attempts);

    expect(progress.totalAttempts, 2);
    expect(progress.areaAccuracy['Matemáticas'], 0.5);
    expect(progress.weakTopics, contains('Matemáticas'));
  });
}
