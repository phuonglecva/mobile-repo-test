# Architecture

## Overview

Milo English is a small local-first Flutter application. It has no backend requirement in the MVP.

    lib/
      main.dart                 App bootstrap + local progress initialization
      app.dart                  MaterialApp and theme setup
      data/lesson_data.dart     Curated beginner vocabulary and topic metadata
      state/progress_store.dart SharedPreferences-backed progress store
      theme/                    Color tokens and Material 3 theme
      screens/                  Home, learning path, lesson, games, rewards, progress
      widgets/                  Reusable mascot, cards, buttons and navigation

## State and persistence

ProgressStore is a singleton ChangeNotifier. It persists stars, coins, completed lessons, learned words and streak locally using shared_preferences. Screens that display those values use AnimatedBuilder to refresh when progress changes.

No child account or personal data is collected in this MVP.

## Learning flow

1. The home screen offers a recommended Animals lesson.
2. The learning path lists six beginner topics.
3. Each topic opens a short vocabulary lesson with picture cues, Vietnamese meanings, example sentences and device text-to-speech.
4. Completing a lesson awards stars and coins and updates local progress.
5. The listening mini-game offers three short questions and a small reward.

## Design system

- Sky blue and vivid blue for primary actions
- Sunshine yellow and tangerine for rewards
- Mint, coral and lavender for topic differentiation
- Large rounded cards and touch targets
- Vietnamese instructions with beginner-level English vocabulary

## Extending the app

- Add new LessonTopic entries in data/lesson_data.dart.
- Add a topic-specific lesson screen or game mode without changing the navigation shell.
- Replace emoji illustrations with licensed local assets when a final illustration pack is ready.
- Add parent settings, curriculum levels and analytics only after validating the learning experience.
