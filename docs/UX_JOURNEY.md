# Milo Adventure World — UX journey

## Product promise

Milo English is a friendly, guided English-learning adventure for Vietnamese primary-school children (ages 6–10). The child should never need to decide what to do next: the map highlights one next lesson and every session ends with clear, encouraging feedback.

## Primary journey

1. **Welcome** — child enters a display name, school grade (1–5) and companion avatar. This profile is stored only on the device.
2. **Adventure Map** — the map is the home screen. The next available world is visually highlighted; completed worlds show a check; future worlds remain locked until the previous world is complete.
3. **Learn** — a short picture-led vocabulary sequence. Each word has a Vietnamese meaning, an example sentence and English text-to-speech.
4. **Play** — the child hears a word and selects the matching picture. Correct answers receive positive feedback. Wrong answers are gentle and can be retried without losing progress.
5. **Celebrate** — completing a world awards 3 stars, 10 coins and 25 XP, then unlocks the next world.
6. **Return** — the Practice tab suggests a completed topic to review. The Profile tab shows progress and streak information.

## Navigation

Keep only three persistent destinations:

- **Hành trình** — the primary learning path and one clear next action.
- **Ôn tập** — replay a learned world and reinforce vocabulary.
- **Hồ sơ** — child profile, progress, badges and a parent tip.

Rewards are part of the lesson completion moment rather than a separate destination. This reduces navigation decisions for young learners.

## Learning session structure

A topic is a short micro-lesson:

- Learn phase: 5 picture vocabulary cards (or fewer when the topic is intentionally shorter).
- Practice phase: listen to each word and choose the matching picture.
- Word-building phase: arrange letter tiles to build one of the new words.
- Completion phase: positive reinforcement, rewards and a clear return to the map.

The UI keeps one primary action visible at a time. Progress is shown at the top of the lesson. Audio is provided by the device's installed English TTS voice.

## Progress and unlock rules

- Alphabet is the first available world.
- Completing a world unlocks the next world.
- Replaying an already completed world does not award duplicate completion rewards, but it still counts as a practice session for the daily habit, streak and weekly goal.
- Progress, profile, stars, coins, XP, completed worlds and streak are stored locally with SharedPreferences.
- Daily streak increments when the learner completes their first world on a new consecutive calendar day.

## Child-friendly interaction principles

- Use short Vietnamese instructions and simple English vocabulary.
- Use large touch targets and readable text.
- Show one primary action per screen.
- Use color plus icons/text to distinguish locked, current and completed nodes.
- Encourage retry; never punish mistakes with lost points or a negative streak.
- Keep sessions short and celebrate effort, not just correctness.

## Current MVP boundaries

- Profile and progress are device-local; there is no account sync or parent account.
- Pronunciation depends on the Android/iOS device TTS engine and installed English voice.
- Vocabulary uses emoji picture cues as a temporary illustration set. Replace with a consistent licensed illustration pack before a public launch.
- The weekly goal is a local count of completed worlds, not a school curriculum assessment.
