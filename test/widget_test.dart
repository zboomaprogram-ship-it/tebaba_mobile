import 'package:flutter_test/flutter_test.dart';
import 'package:tebaba_mobile/main.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TebabaApp());

    // Basic smoke test check for app title/splash
    expect(find.text('طِبابة'), findsOneWidget);
  });
}
