import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:otp_cooldown_button_example/main.dart';

void main() {
  testWidgets('demo displays OTP send button', (tester) async {
    await tester.pumpWidget(const OtpDemoApp());
    expect(find.text('发送验证码'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
