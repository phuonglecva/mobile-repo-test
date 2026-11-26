import 'package:flutter_test/flutter_test.dart';

import 'package:milo_english/app.dart';

void main() {
  testWidgets('Milo English opens the home dashboard', (tester) async {
    await tester.pumpWidget(const MiloEnglishApp());
    await tester.pumpAndSettle();

    expect(find.text('Xin chào, Minh Anh! 👋'), findsOneWidget);
    expect(find.text('Khám phá chủ đề'), findsOneWidget);
  });
}
