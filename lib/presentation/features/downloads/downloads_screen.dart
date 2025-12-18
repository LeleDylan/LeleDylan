import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puntajepro/domain/models/download_pack.dart';
import 'package:puntajepro/presentation/providers/app_start_provider.dart';

final packsProvider = FutureProvider<List<DownloadPack>>((ref) {
  return ref.watch(questionRepositoryProvider).availablePacks();
});

class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packs = ref.watch(packsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Descargas offline')),
      body: packs.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final pack = items[index];
            return Card(
              child: ListTile(
                title: Text(pack.title),
                subtitle: Text('${pack.area} • ${pack.questionCount} preguntas'),
                trailing: ElevatedButton(
                  onPressed: () async {
                    await ref.read(questionRepositoryProvider).downloadPack(pack);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pack descargado para uso offline')),
                    );
                  },
                  child: const Text('Descargar'),
                ),
              ),
            );
          },
        ),
        error: (e, __) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
