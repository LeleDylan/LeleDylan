import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puntajepro/data/firebase/firebase_question_data_source.dart';
import 'package:puntajepro/data/local/local_question_data_source.dart';
import 'package:puntajepro/domain/models/download_pack.dart';
import 'package:puntajepro/domain/models/question.dart';
import 'package:puntajepro/domain/repositories/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  QuestionRepositoryImpl(
    this._local,
    this._remote,
  );

  final LocalQuestionDataSource _local;
  final FirebaseQuestionDataSource _remote;

  @override
  Future<void> cacheQuestions(List<Question> questions) async {
    await _local.cacheQuestions(questions);
  }

  @override
  Future<List<Question>> fetchDailyPlan({int limit = 10}) async {
    final localSeed = await _local.loadSeedQuestions();
    final random = Random();
    localSeed.shuffle(random);
    return localSeed.take(limit).toList();
  }

  @override
  Future<List<Question>> fetchQuickSimulacro({int limit = 10}) async {
    try {
      final remote = await _remote.fetchQuestions(limit: limit);
      if (remote.isNotEmpty) return remote;
    } catch (_) {
      // Permitir fallback offline
    }
    final cached = await getCachedQuestions();
    if (cached.isNotEmpty) return cached.take(limit).toList();
    return fetchDailyPlan(limit: limit);
  }

  @override
  Future<List<DownloadPack>> availablePacks() async {
    return const [
      DownloadPack(id: 'pack_mates', title: 'Matemáticas esenciales', area: 'Matemáticas', questionCount: 15),
      DownloadPack(id: 'pack_lec', title: 'Lectura crítica práctica', area: 'Lectura crítica', questionCount: 15),
      DownloadPack(id: 'pack_ciencias', title: 'Ciencias rápidas', area: 'Ciencias', questionCount: 15),
    ];
  }

  @override
  Future<void> downloadPack(DownloadPack pack) async {
    try {
      final remotePack = await _remote.fetchPack(pack.id);
      await cacheQuestions(remotePack);
    } catch (_) {
      final seed = await _local.loadSeedQuestions();
      await cacheQuestions(seed.where((q) => q.area == pack.area).take(pack.questionCount).toList());
    }
  }

  @override
  Future<List<Question>> getCachedQuestions() async {
    return _local.readCachedQuestions();
  }
}
