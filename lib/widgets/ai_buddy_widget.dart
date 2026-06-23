import 'package:flutter/material.dart';
import '../providers/story_provider.dart';

class AiBuddyWidget extends StatefulWidget {
  final AudioState audioState;
  final QuizState quizState;

  const AiBuddyWidget({
    super.key,
    required this.audioState,
    required this.quizState,
  });

  @override
  State<AiBuddyWidget> createState() => _AiBuddyWidgetState();
}

class _AiBuddyWidgetState extends State<AiBuddyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceCtrl;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _bounce = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    super.dispose();
  }

  String get _message {
    if (widget.quizState == QuizState.correct) return "You got it! Amazing! 🎉";
    if (widget.quizState == QuizState.wrong) return "Hmm, try again! You can do it! 💪";
    if (widget.audioState == AudioState.playing) return "Listen carefully...";
    if (widget.audioState == AudioState.loading) return "Getting the story ready...";
    if (widget.audioState == AudioState.error) return "Oops! Something went wrong.";
    if (widget.audioState == AudioState.done) return "Now answer the question!";
    return "Hi! I'm Pip! Tap below to hear my story!";
  }

  Color get _heroColor {
    if (widget.quizState == QuizState.correct) return const Color(0xFFFFD700);
    if (widget.quizState == QuizState.wrong) return const Color(0xFFFF6B6B);
    if (widget.audioState == AudioState.playing) return const Color(0xFF00CC44);
    return const Color(0xFF00CC44);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounce,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, widget.audioState == AudioState.playing ? _bounce.value : 0),
          child: child,
        );
      },
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: CustomPaint(
                size: const Size(70, 70),
                painter: _HeroPainter(color: _heroColor),
              ),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _message,
              key: ValueKey(_message),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPainter extends CustomPainter {
  final Color color;
  const _HeroPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Body
    paint.color = color;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint);

    // Watch symbol (circle on chest)
    paint.color = Colors.black;
    canvas.drawCircle(Offset(size.width / 2, size.height * 0.62), 10, paint);
    paint.color = Colors.white;
    canvas.drawCircle(Offset(size.width / 2, size.height * 0.62), 7, paint);
    paint.color = Colors.black;
    canvas.drawCircle(Offset(size.width / 2, size.height * 0.62), 4, paint);

    // Eyes
    paint.color = Colors.white;
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.38), 9, paint);
    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.38), 9, paint);

    // Pupils
    paint.color = Colors.black;
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.38), 4, paint);
    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.38), 4, paint);

    // Smile
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.5;
    final path = Path();
    path.moveTo(size.width * 0.3, size.height * 0.52);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.65, size.width * 0.7, size.height * 0.52);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_HeroPainter old) => old.color != color;
}
