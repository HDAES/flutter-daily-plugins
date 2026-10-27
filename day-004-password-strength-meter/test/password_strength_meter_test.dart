import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_strength_meter/password_strength_meter.dart';

void main() {
  testWidgets('empty input shows unchecked rules', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: PasswordStrengthMeter(password: '')),
    ));
    expect(find.text('未输入'), findsOneWidget);
    expect(
      tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      ).value,
      0,
    );
    expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(5));
  });

  testWidgets('rebuilding updates labels and indicators', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: PasswordStrengthMeter(password: 'Abcdefg1')),
    ));
    expect(find.text('良好'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNWidgets(4));

    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: PasswordStrengthMeter(password: 'Abcdefg1!')),
    ));
    expect(find.text('强'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNWidgets(5));
    expect(
      tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      ).value,
      1,
    );
  });

  testWidgets('custom length appears in the checklist', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: PasswordStrengthMeter(password: 'Abcdefg1!', minLength: 12),
      ),
    ));
    expect(find.text('至少 12 个字符'), findsOneWidget);
    expect(find.text('弱'), findsOneWidget);
  });

  testWidgets('optional sections can be hidden', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: PasswordStrengthMeter(
          password: 'Abcdefg1!',
          showLabel: false,
          showRules: false,
          showProgress: false,
        ),
      ),
    ));
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(find.text('密码强度'), findsNothing);
    expect(find.byIcon(Icons.check_circle), findsNothing);
  });
}
