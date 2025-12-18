import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puntajepro/presentation/providers/app_start_provider.dart';
import 'package:puntajepro/presentation/features/home/home_screen.dart';
import 'package:puntajepro/presentation/features/onboarding/onboarding_screen.dart';
import 'package:puntajepro/presentation/widgets/app_theme.dart';

class PuntajeProApp extends ConsumerWidget {
  const PuntajeProApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startState = ref.watch(appStartProvider);

    return MaterialApp(
      title: 'PuntajePro',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: startState.maybeWhen(
        orElse: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        needsOnboarding: () => const OnboardingScreen(),
        ready: () => const HomeScreen(),
        error: (message) => Scaffold(
          body: Center(child: Text('Error de arranque: $message')),
        ),
      ),
    );
  }
}
