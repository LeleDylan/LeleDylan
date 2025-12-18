import 'question.dart';

class Attempt {
  const Attempt({
    required this.questionId,
    required this.selectedIndex,
    required this.isCorrect,
    required this.area,
  });

  final String questionId;
  final int selectedIndex;
  final bool isCorrect;
  final String area;

  factory Attempt.evaluate(Question question, int selectedIndex) {
    final correct = question.answerIndex == selectedIndex;
    return Attempt(
      questionId: question.id,
      selectedIndex: selectedIndex,
      isCorrect: correct,
      area: question.area,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'selectedIndex': selectedIndex,
      'isCorrect': isCorrect,
      'area': area,
    };
  }
}
