import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puntajepro/domain/models/question.dart';
import 'package:puntajepro/presentation/features/downloads/downloads_screen.dart';
import 'package:puntajepro/presentation/features/pro/pro_screen.dart';
import 'package:puntajepro/presentation/features/quiz/quiz_screen.dart';
import 'package:puntajepro/presentation/providers/app_start_provider.dart';

final dailyPlanProvider = FutureProvider<List<Question>>((ref) {
  final repo = ref.watch(questionRepositoryProvider);
  return repo.fetchDailyPlan(limit: 10);
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(dailyPlanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PuntajePro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProScreen()),
            ),
          )
        ],
      ),
      body: plan.when(
        data: (questions) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Plan de hoy (10 preguntas)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...questions.take(10).map((q) => Card(
                  child: ListTile(
                    title: Text(q.statement),
                    subtitle: Text('${q.area} • ${q.topic}'),
                  ),
                )),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => QuizScreen(questions: questions)),
              ),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Simulacro rápido'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DownloadsScreen()),
              ),
              icon: const Icon(Icons.download),
              label: const Text('Descargas offline'),
            ),
          ],
        ),
        error: (e, __) => Center(child: Text('Error cargando plan: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
