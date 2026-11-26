import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:milo_english/app.dart';
import 'package:milo_english/data/lesson_data.dart';
import 'package:milo_english/screens/lesson_screen.dart';
import 'package:milo_english/state/progress_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await ProgressStore.instance.init();
  });

  testWidgets('new learner sees onboarding then the adventure map', (tester) async {
    await tester.pumpWidget(const MiloEnglishApp());

    expect(find.text('Chào mừng đến\nMilo World! 🌈'), findsOneWidget);
    expect(find.text('Bắt đầu hành trình'), findsOneWidget);

    await tester.ensureVisible(find.text('Bắt đầu hành trình'));
    await tester.tap(find.text('Bắt đầu hành trình'));
    await tester.pumpAndSettle();

    expect(find.text('Đường phiêu lưu'), findsOneWidget);
    expect(find.text('Hành trình'), findsOneWidget);
  });

  testWidgets('a lesson teaches, quizzes and builds a word before rewarding', (tester) async {
    await tester.pumpWidget(MaterialApp(home: LessonScreen(topic: lessonTopics.first)));

    for (var index = 0; index < lessonTopics.first.words.length; index++) {
      final label = index == lessonTopics.first.words.length - 1 ? 'Bắt đầu thử thách' : 'Từ tiếp theo';
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }

    for (var index = 0; index < lessonTopics.first.words.length; index++) {
      await tester.tap(find.text(lessonTopics.first.words[index].emoji));
      await tester.pumpAndSettle();
      final label = index == lessonTopics.first.words.length - 1 ? 'Nhận phần thưởng' : 'Câu tiếp theo';
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }

    expect(find.text('Ghép các chữ cái để tạo thành từ'), findsOneWidget);

    for (final tileIndex in [4, 2, 3, 1, 0]) {
      await tester.tap(find.byKey(ValueKey('letter-tile-$tileIndex')));
      await tester.pumpAndSettle();
    }

    expect(find.text('Hoàn thành bài học'), findsOneWidget);
    await tester.tap(find.text('Hoàn thành bài học'));
    await tester.pumpAndSettle();

    expect(find.text('BÉ GIỎI QUÁ!'), findsOneWidget);
    expect(ProgressStore.instance.isTopicCompleted(lessonTopics.first.id), isTrue);
  });

  test('finishing a world unlocks the next world and rewards only once', () async {
    final store = ProgressStore.instance;

    expect(store.isTopicUnlocked(lessonTopics.first.id), isTrue);
    expect(store.isTopicUnlocked(lessonTopics[1].id), isFalse);

    await store.completeTopic(topicId: lessonTopics.first.id, words: 5);

    expect(store.isTopicCompleted(lessonTopics.first.id), isTrue);
    expect(store.isTopicUnlocked(lessonTopics[1].id), isTrue);
    expect(store.xp, 25);
    expect(store.stars, 3);
    expect(store.coins, 10);

    await store.completeTopic(topicId: lessonTopics.first.id, words: 5);

    expect(store.xp, 25);
    expect(store.lessonsCompleted, 1);
  });
}
