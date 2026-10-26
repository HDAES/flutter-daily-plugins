import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:debounced_search_field_example/main.dart';

void main() {
  testWidgets('demo filters local items after debounce', (tester) async {
    await tester.pumpWidget(const DebouncedSearchDemoApp());

    expect(find.text('Flutter Widgets'), findsOneWidget);
    expect(find.text('Dart Collections'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Flutter');
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Flutter Widgets'), findsOneWidget);
    expect(find.text('Dart Collections'), findsNothing);
    expect(find.text('触发搜索次数：1'), findsOneWidget);

    await tester.tap(find.byTooltip('清除搜索'));
    await tester.pump();

    expect(find.text('Dart Collections'), findsOneWidget);
    expect(find.text('触发搜索次数：2'), findsOneWidget);
  });
}
