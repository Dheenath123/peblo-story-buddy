import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/quiz_model.dart';
import '../providers/story_provider.dart';

class QuizWidget extends StatefulWidget {
  final QuizQuestion quiz;
  final QuizState quizState;
  final String? selectedOption;
  final Function(String) onAnswer;
  final VoidCallback onRetry;

  const QuizWidget({
    super.key,
    required this.quiz,
    required this.quizState,
    required this.selectedOption,
    required this.onAnswer,
    required this.onRetry,
  });

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeCtrl;
  late Animation<double> _shake;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shake = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn),
    );
  }

  @override
  void didUpdateWidget(QuizWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.quizState == QuizState.wrong &&
        oldWidget.quizState != QuizState.wrong) {
      HapticFeedback.heavyImpact();
      _shakeCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  Color _optionColor(String option) {
    if (widget.selectedOption == null) return Colors.white;
    if (option == widget.quiz.answer) return const Color(0xFF43C6AC);
    if (option == widget.selectedOption) return const Color(0xFFFF6B6B);
    return Colors.white;
  }

  Color _optionTextColor(String option) {
    if (widget.selectedOption == null) return const Color(0xFF2D2D2D);
    if (option == widget.quiz.answer || option == widget.selectedOption) {
      return Colors.white;
    }
    return const Color(0xFF2D2D2D);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        double offset = 0;
        if (_shakeCtrl.isAnimating) {
          offset = 12 * (0.5 - (_shake.value % 0.5)) * 4;
        }
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: widget.quizState == QuizState.hidden ? 0 : 1,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "🧠 Quiz Time!",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C63FF),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.quiz.question,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              ...widget.quiz.options.map((option) => _buildOption(option)),
              if (widget.quizState == QuizState.wrong) ...[
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: widget.onRetry,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      "Try Again! 💪",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String option) {
    final bool isDisabled = widget.selectedOption != null;
    return GestureDetector(
      onTap: isDisabled ? null : () => widget.onAnswer(option),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: _optionColor(option),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: widget.selectedOption == null
                ? const Color(0xFFE0E0E0)
                : _optionColor(option),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _optionColor(option).withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          option,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _optionTextColor(option),
          ),
        ),
      ),
    );
  }
}
