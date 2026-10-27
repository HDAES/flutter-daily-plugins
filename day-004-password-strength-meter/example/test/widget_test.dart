import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_strength_meter_example/main.dart';

void main() {
  testWidgets('typing updates the meter', (tester) async {
    await tester.pumpWidget(const DemoApp());
    expect(find.text('未输入'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('password_input')), 'Abcdefg1!');
    await tester.pump();
    expect(find.text('强'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNWidgets(5));
  });

  testWidgets('visibility button toggles obscuring', (tester) async {
    await tester.pumpWidget(const DemoApp());
    expect(tester.widget<TextField>(find.byType(TextField)).obscureText, isTrue);
    await tester.tap(find.byTooltip('显示密码'));
    await tester.pump();
    expect(tester.widget<TextField>(find.byType(TextField)).obscureText, isFalse);
  });
}
