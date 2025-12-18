import 'package:flutter/material.dart';
import 'package:puntajepro/domain/models/attempt.dart';
import 'package:puntajepro/domain/models/user_progress.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.progress, required this.attempts});

  final UserProgress progress;
  final List<Attempt> attempts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Score: ${(progress.accuracy * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Por área:'),
            ...progress.areaAccuracy.entries
                .map((e) => ListTile(title: Text(e.key), trailing: Text('${(e.value * 100).toStringAsFixed(0)}%'))),
            const SizedBox(height: 8),
            const Text('Temas débiles:'),
            if (progress.weakTopics.isEmpty)
              const Text('¡Buen trabajo!')
            else
              Wrap(
                spacing: 8,
                children: progress.weakTopics.map((t) => Chip(label: Text(t))).toList(),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
