import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puntajepro/presentation/providers/app_start_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _areas = <String, bool>{
    'Lectura crítica': false,
    'Matemáticas': false,
    'Ciencias': false,
    'Sociales': false,
    'Inglés': false,
  };
  final _goalController = TextEditingController();

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  void _finish() {
    ref.read(appStartProvider.notifier).completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configura tu meta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Objetivo de puntaje (Saber 11):'),
            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Ej. 350'),
            ),
            const SizedBox(height: 16),
            const Text('Áreas a reforzar'),
            ..._areas.keys.map(
              (area) => CheckboxListTile(
                value: _areas[area],
                title: Text(area),
                onChanged: (value) => setState(() => _areas[area] = value ?? false),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _finish,
              child: const Text('Empezar plan'),
            )
          ],
        ),
      ),
    );
  }
}
