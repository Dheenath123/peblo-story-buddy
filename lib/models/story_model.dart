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
  title: "Pip and the Lost Gear",
  text: "Once upon a time, a clever little robot named Pip lost his shiny blue gear in the Whispering Woods...",
  quiz: QuizQuestion.fromJson({
    "question": "What colour was Pip the Robot's lost gear?",
    "options": ["Red", "Green", "Blue", "Yellow"],
    "answer": "Blue"
  }),
);
