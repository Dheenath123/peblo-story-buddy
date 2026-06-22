import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/story_provider.dart';
import '../widgets/ai_buddy_widget.dart';
import '../widgets/story_card_widget.dart';
import '../widgets/quiz_widget.dart';
import '../widgets/success_overlay.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6C63FF),
                      Color(0xFF3B82C4),
                      Color(0xFF43C6AC),
                    ],
                  ),
                ),
              ),
              const Positioned(
                top: 60,
                left: 20,
                child: Text("⭐", style: TextStyle(fontSize: 18, color: Colors.white54)),
              ),
              const Positioned(
                top: 120,
                right: 30,
                child: Text("✨", style: TextStyle(fontSize: 14, color: Colors.white38)),
              ),
              const Positioned(
                top: 80,
                right: 80,
                child: Text("🌟", style: TextStyle(fontSize: 22, color: Colors.white30)),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Peblo",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Story Buddy",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      AiBuddyWidget(
                        audioState: provider.audioState,
                        quizState: provider.quizState,
                      ),
                      const SizedBox(height: 28),
                      StoryCardWidget(
                        storyText: provider.story.text,
                        audioState: provider.audioState,
                        onReadStory: provider.readStory,
                        onStop: provider.stopStory,
                        onRetry: provider.retryAudio,
                      ),
                      if (provider.quizState != QuizState.hidden) ...[
                        const SizedBox(height: 20),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: QuizWidget(
                            key: ValueKey(provider.quizState),
                            quiz: provider.story.quiz,
                            quizState: provider.quizState,
                            selectedOption: provider.selectedOption,
                            onAnswer: provider.answerQuestion,
                            onRetry: provider.retryQuiz,
                          ),
                        ),
                      ],
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              SuccessOverlay(
                show: provider.quizState == QuizState.correct,
                onReset: provider.reset,
              ),
            ],
          ),
        );
      },
    );
  }
}
