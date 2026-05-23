import 'package:flutter_test/flutter_test.dart';
import 'package:ai_content_detector/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NeuralScanApp());
  });
}