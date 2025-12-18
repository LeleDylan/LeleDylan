import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puntajepro/domain/models/question.dart';

class FirebaseQuestionDataSource {
  FirebaseQuestionDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<Question>> fetchQuestions({int limit = 10}) async {
    final snapshot = await _firestore.collection('questions').limit(limit).get();
    return snapshot.docs
        .map((doc) => Question.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<List<Question>> fetchPack(String packId) async {
    final snapshot = await _firestore
        .collection('packs')
        .doc(packId)
        .collection('questions')
        .get();
    return snapshot.docs
        .map((doc) => Question.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }
}
