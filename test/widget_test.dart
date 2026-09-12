import 'package:flutter_test/flutter_test.dart';

import 'package:esimkrd/main.dart';

void main() {
  testWidgets('App builds without splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EsimKrdApp());
    await tester.pump();
    expect(find.byType(EsimKrdApp), findsOneWidget);
  });
}
