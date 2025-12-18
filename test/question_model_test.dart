import 'package:flutter_test/flutter_test.dart';
import 'package:puntajepro/domain/models/question.dart';

void main() {
  test('Question serializes to map and back', () {
    const question = Question(
      id: 'q1',
      area: 'Matemáticas',
      topic: 'Álgebra',
      statement: '2x=4',
      options: ['1', '2', '3', '4'],
      answerIndex: 1,
      explanation: 'x=2',
    );

    final map = question.toMap();
    final restored = Question.fromMap(map);

    expect(restored.id, question.id);
    expect(restored.options.length, 4);
    expect(restored.answerIndex, 1);
  });
}
