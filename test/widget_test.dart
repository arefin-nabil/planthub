import 'package:flutter_test/flutter_test.dart';
import 'package:planthub/app/app.dart';

void main() {
  testWidgets('PlantHub app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PlantHubApp());
    await tester.pump(const Duration(milliseconds: 500));
    // App should build without errors
    expect(tester.takeException(), isNull);
  });
}
