import 'package:puntajepro/domain/models/attempt.dart';
import 'package:puntajepro/domain/models/user_progress.dart';

abstract class ProgressRepository {
  Future<UserProgress> recordAttempts(List<Attempt> attempts);
  Future<UserProgress> loadProgress();
}
