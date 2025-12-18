class UserProgress {
  const UserProgress({
    required this.totalAttempts,
    required this.correctAnswers,
    required this.areaAccuracy,
    required this.weakTopics,
  });

  final int totalAttempts;
  final int correctAnswers;
  final Map<String, double> areaAccuracy;
  final List<String> weakTopics;

  double get accuracy => totalAttempts == 0 ? 0 : correctAnswers / totalAttempts;

  factory UserProgress.empty() {
    return const UserProgress(
      totalAttempts: 0,
      correctAnswers: 0,
      areaAccuracy: {},
      weakTopics: [],
    );
  }

  UserProgress merge(UserProgress other) {
    final combinedAttempts = totalAttempts + other.totalAttempts;
    final combinedCorrect = correctAnswers + other.correctAnswers;
    final mergedArea = <String, double>{...areaAccuracy};
    other.areaAccuracy.forEach((key, value) {
      mergedArea[key] = value;
    });
    final mergedWeakTopics = {...weakTopics, ...other.weakTopics}.toList();

    return UserProgress(
      totalAttempts: combinedAttempts,
      correctAnswers: combinedCorrect,
      areaAccuracy: mergedArea,
      weakTopics: mergedWeakTopics,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalAttempts': totalAttempts,
      'correctAnswers': correctAnswers,
      'areaAccuracy': areaAccuracy,
      'weakTopics': weakTopics,
    };
  }

  factory UserProgress.fromMap(Map<String, dynamic> map) {
    return UserProgress(
      totalAttempts: map['totalAttempts'] as int,
      correctAnswers: map['correctAnswers'] as int,
      areaAccuracy: Map<String, double>.from(map['areaAccuracy'] as Map),
      weakTopics: (map['weakTopics'] as List).map((e) => e.toString()).toList(),
    );
  }
}
