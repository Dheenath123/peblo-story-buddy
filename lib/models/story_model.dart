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

final Story sampleStory = Story(
  title: "sudhakar and his food",
  text: "Once upon a time, there lived a ghost his name is sudhu sudhakar he sold porota",
  quiz: QuizQuestion.fromJson({
    "question": "What did Sudhakar sells ",
    "options": ["porota", "puri", "pongal", "idly"],
    "answer": "porota"
  }),
);
