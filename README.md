# Milo English 🦊

A playful, guided English-learning adventure for Vietnamese primary-school children (ages 6–10), built with Flutter.

**Milo Adventure World** replaces a generic dashboard with a clear learning journey: children create a simple profile, follow a colorful map, learn five beginner words per world, play a listening game, celebrate progress and return for short reviews.

## Experience

- First-run onboarding: child name, grade 1–5 and companion avatar
- Guided adventure map with current, completed and locked worlds
- Six beginner worlds: Alphabet, Numbers, Colors, Animals, Family and Food
- Five picture-led vocabulary cards per world with Vietnamese meanings and example sentences
- English text-to-speech for words and example sentences
- Listening quiz with large picture choices and gentle retry feedback
- Word-building exercise with letter tiles
- Completion celebration: stars, coins and XP; next world unlocks
- Practice hub to replay learned worlds
- Child profile with progress, streaks and earned badges
- Local progress persistence; no backend or account required for MVP
- Custom vector-drawn Milo fox mascot and animated UI transitions

## Navigation

- **Hành trình** — the main learning path and one highlighted next lesson
- **Ôn tập** — review a completed topic
- **Hồ sơ** — learner progress and parent-friendly summary

## Tech stack

- Flutter / Dart with Material 3
- flutter_tts for pronunciation using the device's installed voice
- shared_preferences for local profile and progress

## Quick start

1. Install Flutter SDK (stable channel) and Android Studio / Android SDK.
2. Clone this repository.
3. Generate the Android platform folder once:
   - Ubuntu: bash scripts/bootstrap_android.sh
   - Windows PowerShell: .\scripts\bootstrap_android.ps1
4. Run flutter pub get, then flutter run.

See docs/GETTING_STARTED.md, docs/UX_JOURNEY.md, docs/ARCHITECTURE.md and docs/BUILD_APK.md.

## Build Android APK

~~~bash
flutter build apk --release
~~~

Output: build/app/outputs/flutter-apk/app-release.apk

A GitHub Actions workflow builds the release APK on pushes to main and uploads it as an artifact.

## Project structure

    lib/
      app.dart
      main.dart
      data/
      screens/
      state/
      theme/
      widgets/
    docs/
    scripts/
    .github/workflows/

## Design direction

A bright sky-blue, vivid-blue, sunshine-yellow, tangerine, mint and lavender palette; rounded child-friendly controls; expressive custom Milo fox illustration; large touch targets; Vietnamese guidance; and short beginner English learning activities.
