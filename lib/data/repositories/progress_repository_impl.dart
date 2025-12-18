import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:puntajepro/domain/models/attempt.dart';
import 'package:puntajepro/domain/models/user_progress.dart';
import 'package:puntajepro/domain/repositories/progress_repository.dart';
import 'package:puntajepro/domain/usecases/score_calculator.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl(this._firestore);

  final FirebaseFirestore _firestore;
  static const _progressBox = 'progress_box';

  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_progressBox)) return Hive.box(_progressBox);
    return Hive.openBox(_progressBox);
  }

  @override
  Future<UserProgress> loadProgress() async {
    final box = await _openBox();
    final cached = box.get('progress');
    if (cached != null) {
      return UserProgress.fromMap(Map<String, dynamic>.from(cached as Map));
    }
    return UserProgress.empty();
  }

  @override
  Future<UserProgress> recordAttempts(List<Attempt> attempts) async {
    final progress = ScoreCalculator().buildProgress(attempts);

    final box = await _openBox();
    await box.put('progress', progress.toMap());

    try {
      await _firestore.collection('progress').doc('current').set(progress.toMap());
    } catch (_) {
      // Permitir modo offline sin fallar
    }

    return progress;
  }
}
