import 'package:puntajepro/domain/models/download_pack.dart';
import 'package:puntajepro/domain/models/question.dart';

abstract class QuestionRepository {
  Future<List<Question>> fetchDailyPlan({int limit});
  Future<List<Question>> fetchQuickSimulacro({int limit});
  Future<void> downloadPack(DownloadPack pack);
  Future<List<DownloadPack>> availablePacks();
  Future<void> cacheQuestions(List<Question> questions);
  Future<List<Question>> getCachedQuestions();
}
