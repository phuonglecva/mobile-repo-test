# Milo English 🦊

A colorful, game-inspired English learning app for Vietnamese primary-school students (ages 6–10), built with Flutter.

Milo is a friendly fox who guides children through short beginner lessons, picture vocabulary, listening practice, mini-games and collectible rewards. The first release is local-first: no account, server or internet connection is required for the learning flow. Device text-to-speech uses an installed English voice.

## Features

- Playful home dashboard with daily mission, streak and learning progress
- Beginner learning path: Alphabet, Numbers, Colors, Animals, Family and Food
- Picture-led vocabulary cards with English text-to-speech
- Listening multiple-choice mini-game
- Stars, coins, badges and progress summary
- Local progress persistence with shared_preferences
- Responsive layouts for common Android phone sizes

## Tech stack

- Flutter / Dart
- Material 3 with a custom colorful design system
- flutter_tts for pronunciation
- shared_preferences for local progress

## Quick start

1. Install Flutter SDK (stable channel) and Android Studio / Android SDK.
2. Clone this repository.
3. Generate the Android platform folder once:
   - Ubuntu: bash scripts/bootstrap_android.sh
   - Windows PowerShell: .\scripts\bootstrap_android.ps1
4. Run flutter pub get, then flutter run.

See docs/GETTING_STARTED.md, docs/ARCHITECTURE.md and docs/BUILD_APK.md for complete instructions.

## Android APK

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

Milo English uses a bright sky-blue, sunshine-yellow, tangerine and mint palette, large rounded controls, friendly illustrations and game-like progress feedback. Interface copy is Vietnamese; target vocabulary and example sentences are beginner English.
