import 'package:puntajepro/domain/models/attempt.dart';
import 'package:puntajepro/domain/models/user_progress.dart';

class ScoreCalculator {
  UserProgress buildProgress(List<Attempt> attempts) {
    if (attempts.isEmpty) {
      return UserProgress.empty();
    }

    final total = attempts.length;
    final correct = attempts.where((a) => a.isCorrect).length;
    final areaTotals = <String, int>{};
    final areaCorrect = <String, int>{};

    for (final attempt in attempts) {
      areaTotals.update(attempt.area, (value) => value + 1, ifAbsent: () => 1);
      if (attempt.isCorrect) {
        areaCorrect.update(attempt.area, (value) => value + 1, ifAbsent: () => 1);
      }
    }

    final areaAccuracy = <String, double>{};
    areaTotals.forEach((key, value) {
      final correctCount = areaCorrect[key] ?? 0;
      areaAccuracy[key] = value == 0 ? 0 : correctCount / value;
    });

    final weakTopics = attempts
        .where((a) => !a.isCorrect)
        .map((a) => a.area)
        .toSet()
        .toList();

    return UserProgress(
      totalAttempts: total,
      correctAnswers: correct,
      areaAccuracy: areaAccuracy,
      weakTopics: weakTopics,
    );
  }
}
