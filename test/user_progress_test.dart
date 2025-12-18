import 'package:flutter_test/flutter_test.dart';
import 'package:puntajepro/domain/models/user_progress.dart';

void main() {
  test('UserProgress merges totals', () {
    final a = UserProgress(
      totalAttempts: 5,
      correctAnswers: 3,
      areaAccuracy: {'Matemáticas': 0.6},
      weakTopics: ['Lectura crítica'],
    );
    final b = UserProgress(
      totalAttempts: 3,
      correctAnswers: 2,
      areaAccuracy: {'Ciencias': 0.5},
      weakTopics: ['Matemáticas'],
    );

    final merged = a.merge(b);

    expect(merged.totalAttempts, 8);
    expect(merged.correctAnswers, 5);
    expect(merged.areaAccuracy.keys.length, 2);
    expect(merged.weakTopics.length, 2);
  });
}
