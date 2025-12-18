import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puntajepro/domain/models/attempt.dart';
import 'package:puntajepro/domain/models/question.dart';
import 'package:puntajepro/presentation/features/quiz/results_screen.dart';
import 'package:puntajepro/presentation/providers/app_start_provider.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, required this.questions});

  final List<Question> questions;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int currentIndex = 0;
  int? selectedIndex;
  bool answered = false;
  final attempts = <Attempt>[];

  Question get currentQuestion => widget.questions[currentIndex];

  void _confirm() {
    if (selectedIndex == null) return;
    final attempt = Attempt.evaluate(currentQuestion, selectedIndex!);
    attempts.add(attempt);
    setState(() {
      answered = true;
    });
  }

  void _next() {
    if (currentIndex + 1 >= widget.questions.length) {
      ref.read(progressRepositoryProvider).recordAttempts(attempts).then((progress) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ResultsScreen(
              progress: progress,
              attempts: attempts,
            ),
          ),
        );
      });
      return;
    }
    setState(() {
      currentIndex++;
      selectedIndex = null;
      answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = currentQuestion;
    return Scaffold(
      appBar: AppBar(title: Text('Pregunta ${currentIndex + 1}/${widget.questions.length}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q.statement, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...List.generate(q.options.length, (index) {
              final option = q.options[index];
              final isCorrect = index == q.answerIndex;
              Color? color;
              if (answered) {
                if (isCorrect) {
                  color = Colors.green.shade200;
                } else if (selectedIndex == index) {
                  color = Colors.red.shade200;
                }
              }
              return Card(
                color: color,
                child: RadioListTile<int>(
                  value: index,
                  groupValue: selectedIndex,
                  onChanged: answered ? null : (v) => setState(() => selectedIndex = v),
                  title: Text(option),
                ),
              );
            }),
            if (answered)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Explicación: ${q.explanation}'),
              ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: answered ? _next : _confirm,
                    child: Text(answered ? 'Siguiente' : 'Confirmar'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
