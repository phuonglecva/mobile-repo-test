import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:milo_english/app.dart';
import 'package:milo_english/data/lesson_data.dart';
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
