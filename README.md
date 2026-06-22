# Peblo Story Buddy 🤖📖

**Peblo Flutter/Swift Developer Intern Challenge**  
*"The AI Story Buddy & Quiz Component"*

---

## Framework Choice: Flutter

**Why Flutter?**  
Flutter was chosen for its single-codebase cross-platform support (Android + iOS), smooth 60fps animations, and strong ecosystem for TTS (`flutter_tts`), state management (`provider`), and animation (`confetti`). Given Peblo's primary audience is on mid-range Android devices (~3GB RAM), Flutter's compiled Dart engine is significantly lighter than React Native and handles animation-heavy UIs well.

---

## Architecture

```
lib/
├── main.dart                    # App entry point
├── models/
│   ├── quiz_model.dart          # QuizQuestion - parsed from JSON
│   └── story_model.dart         # Story model + sample data
├── providers/
│   └── story_provider.dart      # ChangeNotifier: TTS + quiz state
├── screens/
│   └── home_screen.dart         # Single-screen layout
└── widgets/
    ├── ai_buddy_widget.dart     # Pip the robot character
    ├── story_card_widget.dart   # Story text + TTS button
    ├── quiz_widget.dart         # Data-driven quiz renderer
    └── success_overlay.dart     # Confetti success state
```

---

## How I Managed the Transition State (Audio → Quiz)

The `StoryProvider` uses `FlutterTts.setCompletionHandler()` to detect when narration ends. On completion, `audioState` moves to `done` and `quizState` flips from `hidden` → `active`. This triggers an `AnimatedSwitcher` in the UI that smoothly fades the quiz card in. No timers or polling — it's event-driven.

---

## How the Quiz is Data-Driven

The quiz is never hardcoded. `QuizQuestion.fromJson()` accepts any JSON with:
```json
{
  "question": "...",
  "options": ["A", "B", "C"],   // 3, 4, or 5 options — any count works
  "answer": "B"
}
```
The options list is rendered with `.map()` so adding/removing options requires zero code changes. A different question from the backend would just need `QuizQuestion.fromJson(newJson)`.

---

## Caching Approach

The current story text is in-memory (simulating a backend response). For remote audio (e.g. ElevenLabs):
- Cache the audio file to the device's temporary directory using `path_provider`.
- Check for a cached file before making a network request (keyed by story ID + hash).
- On failure, fall back gracefully to the native TTS engine.

This approach avoids redundant API calls and works offline after first load.

---

## Audio Loading & Failure Handling

| State | Behavior |
|-------|----------|
| `loading` | Shows a spinner in the button |
| `playing` | Button becomes "Stop", Pip bounces |
| `done` | Quiz appears, button becomes "Read Again" |
| `error` | Error message shown, "Try Again" button offered |

TTS failures are caught in `setErrorHandler` and surfaced to the user without crashing the app.

---

## Performance Profiling

- **Animations**: `AnimationController` used for Pip's bounce. Runs on the Raster thread — no jank observed.
- **Widget rebuilds**: `Consumer<StoryProvider>` wraps only the subtree that needs updates. The static background gradient and decorations never rebuild.
- **Confetti**: `ConfettiWidget` is conditionally mounted only on success — not rendered at all otherwise.
- **Target**: Tested on mid-range spec (3GB RAM emulator). Achieved consistent 60fps for all transitions.

---

## AI Usage & Judgment

**Where I used AI assistance:** Claude helped scaffold the initial `ChangeNotifier` structure and suggested using `setCompletionHandler()` for the audio→quiz transition.

**What I rejected:** AI suggested using `StreamBuilder` with a TTS stream — I rejected this because `FlutterTts` uses callbacks, not streams, and wrapping it would add unnecessary complexity with no benefit.

**What didn't work:** Initially tried `flutter_tts` with `awaitSpeakCompletion(true)` — this blocked the UI thread on some Android emulators. Switched to callback-based handlers instead.

---

## Running the Project

```bash
flutter pub get
flutter run
```

Requires Flutter 3.x+. TTS works on physical devices and most emulators with TTS engine installed.

---

## Submission
- **Role:** Mobile App Developer
- **File name:** `mobile_app_developer_challenge_<your_name>`
