import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guarded_async_button/guarded_async_button.dart';

void main() {
  testWidgets('only calls onPressed once while pending', (tester) async {
    final completer = Completer<void>();
    var calls = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GuardedAsyncButton(
            label: '提交',
            onPressed: () {
              calls++;
              return completer.future;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('提交'));
    await tester.pump();

    expect(calls, 1);
    expect(find.text('处理中…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNull);

    await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
    await tester.pump();
    expect(calls, 1);

    completer.complete();
    await tester.pump();
    expect(find.text('提交'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNotNull);

    await tester.tap(find.text('提交'));
    await tester.pump();
    expect(calls, 2);
  });

  testWidgets('reports error to callback and unlocks button', (tester) async {
    final completer = Completer<void>();
    Object? caught;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GuardedAsyncButton(
            label: '提交',
            onPressed: () => completer.future,
            onError: (error, _) => caught = error,
          ),
        ),
      ),
    );

    await tester.tap(find.text('提交'));
    await tester.pump();
    completer.completeError(StateError('network failed'));
    await tester.pump();

    expect(caught, isA<StateError>());
    expect(find.text('提交'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNotNull);
  });

  testWidgets('does not run when disabled', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GuardedAsyncButton(
            label: '提交',
            enabled: false,
            onPressed: () async {
              calls++;
            },
          ),
        ),
      ),
    );

    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNull);
    await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
    await tester.pump();
    expect(calls, 0);
  });

  testWidgets('does not call setState after disposal', (tester) async {
    final completer = Completer<void>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GuardedAsyncButton(
            label: '提交',
            onPressed: () => completer.future,
          ),
        ),
      ),
    );

    await tester.tap(find.text('提交'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    completer.complete();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
