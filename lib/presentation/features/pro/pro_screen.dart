import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puntajepro/presentation/providers/app_start_provider.dart';

class ProScreen extends ConsumerWidget {
  const ProScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('PuntajePro+')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Beneficios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const ListTile(
              leading: Icon(Icons.offline_pin),
              title: Text('Modo offline completo'),
            ),
            const ListTile(
              leading: Icon(Icons.analytics),
              title: Text('Analíticas avanzadas y progreso por tema'),
            ),
            const ListTile(
              leading: Icon(Icons.school),
              title: Text('Simulacros ilimitados y explicaciones premium'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await ref.read(subscriptionRepositoryProvider).purchaseMonthly();
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Compra iniciada')));
                }
              },
              child: const Text('Suscribirme - pro_monthly'),
            ),
          ],
        ),
      ),
    );
  }
}
