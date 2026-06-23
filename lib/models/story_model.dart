import 'quiz_model.dart';

class Story {
  final String title;
  final String text;
  final QuizQuestion quiz;

  Story({
    required this.title,
    required this.text,
    required this.quiz,
  });
}

final List<Story> allStories = [
  Story(
    title: "sudha and jason",
    text: "Once upon a time, sudha and jason was good friends...",
    quiz: QuizQuestion.fromJson({
      "question": "how does sudha knows jason?",
      "options": ["neighbour", "enimies", "friends", "relatives"],
      "answer": "friends"
    }),
  ),
  Story(
    title: "sudha's exam",
    text: "sudha romed with jason without learning for his exams so he failed and his chemistry teacher scoled him...",
    quiz: QuizQuestion.fromJson({
      "question": "Which teacher scoled sudha?",
      "options": ["chemistry", "english", "maths", "physics"],
      "answer": "chemistry"
    }),
  ),
  Story(
    title: "sudha and his success",
    text: "sudha now realised why he failed in exam and now he started to concentrate more in studies he also played little and got good marks his chemistry teacher appreciated him...",
    quiz: QuizQuestion.fromJson({
      "question": "how did sudha got good marks in chemistry?",
      "options": ["copied", "studied", "absent", "cheated"],
      "answer": "studied"
    }),
  ),
];

// Keep this for backward compatibility
final Story sampleStory = allStories[0];
