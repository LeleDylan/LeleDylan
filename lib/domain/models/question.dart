class Question {
  const Question({
    required this.id,
    required this.area,
    required this.topic,
    required this.statement,
    required this.options,
    required this.answerIndex,
    required this.explanation,
  });

  final String id;
  final String area;
  final String topic;
  final String statement;
  final List<String> options;
  final int answerIndex;
  final String explanation;

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] as String,
      area: map['area'] as String,
      topic: map['topic'] as String,
      statement: map['statement'] as String,
      options: (map['options'] as List).map((e) => e.toString()).toList(),
      answerIndex: map['answerIndex'] as int,
      explanation: map['explanation'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'area': area,
      'topic': topic,
      'statement': statement,
      'options': options,
      'answerIndex': answerIndex,
      'explanation': explanation,
    };
  }
}
