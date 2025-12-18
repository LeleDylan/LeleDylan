import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:puntajepro/data/firebase/firebase_question_data_source.dart';
import 'package:puntajepro/data/local/local_question_data_source.dart';
import 'package:puntajepro/data/repositories/question_repository_impl.dart';
import 'package:puntajepro/domain/models/download_pack.dart';
import 'package:puntajepro/domain/models/question.dart';

class _MockLocal extends Mock implements LocalQuestionDataSource {}

class _MockRemote extends Mock implements FirebaseQuestionDataSource {}

void main() {
  setUpAll(() {
    registerFallbackValue(const DownloadPack(id: 'demo', title: 'Demo', area: 'Test', questionCount: 1));
  });

  test('QuestionRepository falls back to cache when remote fails', () async {
    final local = _MockLocal();
    final remote = _MockRemote();
    final repo = QuestionRepositoryImpl(local, remote);
    final cachedQuestion = Question(
      id: 'q1',
      area: 'Demo',
      topic: 'Test',
      statement: 'Demo',
      options: const ['a', 'b', 'c', 'd'],
      answerIndex: 0,
      explanation: 'demo',
    );

    when(() => remote.fetchQuestions(limit: any(named: 'limit'))).thenThrow(Exception('fail'));
    when(() => local.readCachedQuestions()).thenAnswer((_) async => [cachedQuestion]);
    when(() => local.loadSeedQuestions()).thenAnswer((_) async => [cachedQuestion]);

    final result = await repo.fetchQuickSimulacro(limit: 1);

    expect(result.first.id, 'q1');
    verify(() => local.readCachedQuestions()).called(1);
  });
}
