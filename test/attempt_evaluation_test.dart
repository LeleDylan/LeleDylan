import 'package:flutter_test/flutter_test.dart';
import 'package:puntajepro/domain/models/attempt.dart';
import 'package:puntajepro/domain/models/question.dart';

void main() {
  test('Attempt marks correct answer', () {
    const question = Question(
      id: 'q2',
      area: 'Lectura crítica',
      topic: 'Inferencia',
      statement: 'Pregunta',
      options: ['a', 'b', 'c', 'd'],
      answerIndex: 2,
      explanation: 'Porque sí',
    );

    final attempt = Attempt.evaluate(question, 2);

    expect(attempt.isCorrect, true);
    expect(attempt.questionId, question.id);
  });
}
