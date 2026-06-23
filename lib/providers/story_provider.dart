import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/story_model.dart';

enum AudioState { idle, loading, playing, done, error }

enum QuizState { hidden, active, correct, wrong }

class StoryProvider extends ChangeNotifier {
  final FlutterTts _tts = FlutterTts();

  AudioState audioState = AudioState.idle;
  QuizState quizState = QuizState.hidden;
  String? selectedOption;
  String? errorMessage;
  int _currentIndex = 0;

  Story get story => allStories[_currentIndex];
  int get currentIndex => _currentIndex;
  int get totalStories => allStories.length;

  StoryProvider() {
    _initTts();
  }

  void _initTts() {
    _tts.setStartHandler(() {
      audioState = AudioState.playing;
      notifyListeners();
    });

    _tts.setCompletionHandler(() {
      audioState = AudioState.done;
      quizState = QuizState.active;
      notifyListeners();
    });

    _tts.setCancelHandler(() {
      audioState = AudioState.idle;
      notifyListeners();
    });

    _tts.setErrorHandler((msg) {
      audioState = AudioState.error;
      errorMessage = msg.toString();
      notifyListeners();
    });
  }

  void nextStory() {
    if (_currentIndex < allStories.length - 1) {
      _currentIndex++;
      reset();
    }
  }

  void previousStory() {
    if (_currentIndex > 0) {
      _currentIndex--;
      reset();
    }
  }

  Future<void> readStory() async {
    if (audioState == AudioState.playing) return;
    audioState = AudioState.loading;
    notifyListeners();
    try {
      await _tts.setLanguage("en-US");
      await _tts.setSpeechRate(0.45);
      await _tts.setPitch(1.1);
      await _tts.speak(story.text);
    } catch (e) {
      audioState = AudioState.error;
      errorMessage = "Oops! Could not play audio. Please try again.";
      notifyListeners();
    }
  }

  Future<void> stopStory() async {
    await _tts.stop();
    audioState = AudioState.idle;
    notifyListeners();
  }

  void retryAudio() {
    audioState = AudioState.idle;
    errorMessage = null;
    notifyListeners();
    readStory();
  }

  void answerQuestion(String option) {
    selectedOption = option;
    if (option == story.quiz.answer) {
      quizState = QuizState.correct;
    } else {
      quizState = QuizState.wrong;
    }
    notifyListeners();
  }

  void retryQuiz() {
    selectedOption = null;
    quizState = QuizState.active;
    notifyListeners();
  }

  void reset() {
    _tts.stop();
    audioState = AudioState.idle;
    quizState = QuizState.hidden;
    selectedOption = null;
    errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}
