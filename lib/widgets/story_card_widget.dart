import 'package:flutter/material.dart';
import '../providers/story_provider.dart';

class StoryCardWidget extends StatelessWidget {
  final String storyText;
  final AudioState audioState;
  final VoidCallback onReadStory;
  final VoidCallback onStop;
  final VoidCallback onRetry;

  const StoryCardWidget({
    super.key,
    required this.storyText,
    required this.audioState,
    required this.onReadStory,
    required this.onStop,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE066),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "📖 Story",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5C4400),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            storyText,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF2D2D2D),
              height: 1.7,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
          _buildButton(context),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    if (audioState == AudioState.error) {
      return Column(
        children: [
          const Text(
            "Oops! Couldn't play audio.",
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
          const SizedBox(height: 8),
          _actionButton(
            label: "Try Again",
            icon: Icons.refresh_rounded,
            color: const Color(0xFFFF6B6B),
            onTap: onRetry,
          ),
        ],
      );
    }
    if (audioState == AudioState.loading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF6C63FF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFF6C63FF),
              ),
            ),
            SizedBox(width: 12),
            Text(
              "Getting story ready...",
              style: TextStyle(
                color: Color(0xFF6C63FF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
    if (audioState == AudioState.playing) {
      return _actionButton(
        label: "Stop",
        icon: Icons.stop_rounded,
        color: const Color(0xFFFF6B6B),
        onTap: onStop,
      );
    }
    if (audioState == AudioState.done) {
      return _actionButton(
        label: "Read Again",
        icon: Icons.replay_rounded,
        color: const Color(0xFF43C6AC),
        onTap: onReadStory,
      );
    }
    return _actionButton(
      label: "Read Me a Story",
      icon: Icons.volume_up_rounded,
      color: const Color(0xFF6C63FF),
      onTap: onReadStory,
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
