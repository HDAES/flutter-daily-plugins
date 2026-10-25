import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otp_cooldown_button/otp_cooldown_button.dart';

void main() {
  testWidgets('locks while sending, then counts down and allows resend',
      (tester) async {
    final completer = Completer<void>();
    var sends = 0;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: OtpCooldownButton(
          cooldownSeconds: 3,
          onSend: () {
            sends++;
            return sends == 1 ? completer.future : Future<void>.value();
          },
        ),
      ),
    ));

    await tester.tap(find.text('发送验证码'));
    await tester.pump();
    expect(sends, 1);
    expect(find.text('发送中…'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNull);

    await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
    await tester.pump();
    expect(sends, 1);

    completer.complete();
    await tester.pump();
    expect(find.text('3 秒后重发'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('2 秒后重发'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('1 秒后重发'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('发送验证码'), findsOneWidget);

    await tester.tap(find.text('发送验证码'));
    await tester.pump();
    expect(sends, 2);
    expect(find.text('3 秒后重发'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('failed send invokes onError and does not start cooldown',
      (tester) async {
    var sends = 0;
    Object? caught;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: OtpCooldownButton(
          cooldownSeconds: 3,
          onSend: () async {
            sends++;
            throw StateError('server rejected request');
          },
          onError: (error, _) => caught = error,
        ),
      ),
    ));

    await tester.tap(find.text('发送验证码'));
    await tester.pump();
    expect(caught, isA<StateError>());
    expect(find.text('发送验证码'), findsOneWidget);
    await tester.tap(find.text('发送验证码'));
    await tester.pump();
    expect(sends, 2);
  });

  testWidgets('disabled button cannot send', (tester) async {
    var sends = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: OtpCooldownButton(
          enabled: false,
          onSend: () async {
            sends++;
          },
        ),
      ),
    ));

    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNull);
    await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
    await tester.pump();
    expect(sends, 0);
  });

  testWidgets('disposing while send is pending causes no setState error',
      (tester) async {
    final completer = Completer<void>();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: OtpCooldownButton(onSend: () => completer.future),
      ),
    ));
    await tester.tap(find.text('发送验证码'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    completer.complete();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}