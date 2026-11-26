# Architecture

## Overview

Milo English is a local-first Flutter app. The MVP has no backend, login or network dependency for its learning flow.

    lib/
      main.dart                  App bootstrap + local progress initialization
      app.dart                   MaterialApp and theme setup
      data/lesson_data.dart      Beginner vocabulary and world metadata
      state/progress_store.dart  SharedPreferences-backed profile and progress
      theme/                      Color tokens and Material 3 theme
      screens/                   Onboarding, journey map, lesson, practice, profile
      widgets/                   Milo vector mascot, navigation and reusable controls

## User journey

1. First launch opens child-friendly onboarding.
2. The child chooses a display name, grade (1–5) and companion avatar.
3. The adventure map becomes the home screen and highlights one next available world.
4. A world contains a picture-led learn phase, a listening picture quiz and a short word-building exercise.
5. Correct answers receive immediate positive feedback; incorrect answers can be retried.
6. Completing a world awards 3 stars, 10 coins and 25 XP, then unlocks the next world.
7. Practice allows replay; Profile shows progress and streaks.

See docs/UX_JOURNEY.md for the flow and behavior rules.

## State and persistence

ProgressStore is a singleton ChangeNotifier. It persists the child profile, completed world IDs, stars, coins, XP, learned word count, completed lessons, current streak and weekly lesson count using shared_preferences.

Completion rewards are awarded once per world. Replaying a completed world does not duplicate completion rewards.

## Learning content

Six beginner topics are defined in data/lesson_data.dart. Each topic contains vocabulary items with an English word, Vietnamese meaning, picture cue and example sentence. Add or revise content in this file without changing the navigation shell.

## Design system

- Sky blue and vivid blue for primary actions
- Sunshine yellow and tangerine for rewards
- Mint, coral and lavender for world differentiation
- Large rounded controls and generous touch targets
- Custom vector-drawn Milo fox mascot
- Animated progress, feedback and state transitions

## Current MVP boundaries

- No user accounts, cloud sync or parent login
- Device text-to-speech voice availability depends on the OS
- Emoji vocabulary cues are placeholders until a licensed illustration pack is added
- The weekly goal is a local learning habit metric, not a formal curriculum score
