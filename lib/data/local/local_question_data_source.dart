import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:puntajepro/domain/models/question.dart';

class LocalQuestionDataSource {
  static const _cacheBox = 'question_cache';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(_cacheBox);
  }

  Future<List<Question>> loadSeedQuestions() async {
    final raw = await rootBundle.loadString('assets/seed/questions.json');
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Question.fromMap(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<void> cacheQuestions(List<Question> questions) async {
    final box = Hive.box<Map>(_cacheBox);
    await box.put('cached', {
      'items': questions.map((q) => q.toMap()).toList(),
      'savedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Question>> readCachedQuestions() async {
    final box = Hive.box<Map>(_cacheBox);
    final cached = box.get('cached');
    if (cached == null) return [];
    final items = (cached['items'] as List<dynamic>)
        .map((e) => Question.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
    return items;
  }
}
