import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:debounced_search_field/debounced_search_field.dart';

Widget harness({
  required ValueChanged<String> onSearch,
  Duration debounceDuration = const Duration(milliseconds: 350),
  TextEditingController? controller,
  bool enabled = true,
  VoidCallback? onCleared,
}) {
  return MaterialApp(
    home: Scaffold(
      body: DebouncedSearchField(
        onSearch: onSearch,
        debounceDuration: debounceDuration,
        controller: controller,
        enabled: enabled,
        onCleared: onCleared,
      ),
    ),
  );
}

void main() {
  testWidgets('only the final query is emitted after idle time', (tester) async {
    final queries = <String>[];
    await tester.pumpWidget(harness(onSearch: queries.add));

    await tester.enterText(find.byType(TextField), 'f');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.enterText(find.byType(TextField), 'fl');
    await tester.pump(const Duration(milliseconds: 349));
    expect(queries, isEmpty);

    await tester.pump(const Duration(milliseconds: 1));
    expect(queries, <String>['fl']);
  });

  testWidgets('clear emits empty immediately and cancels pending work',
      (tester) async {
    final queries = <String>[];
    var cleared = 0;
    await tester.pumpWidget(harness(
      onSearch: queries.add,
      onCleared: () => cleared++,
    ));

    await tester.enterText(find.byType(TextField), 'flutter');
    await tester.pump(const Duration(milliseconds: 350));
    expect(queries, <String>['flutter']);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pump();
    expect(queries, <String>['flutter', '']);
    expect(cleared, 1);
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, '');

    await tester.pump(const Duration(seconds: 1));
    expect(queries, <String>['flutter', '']);
  });

  testWidgets('keyboard search submits immediately without duplicate',
      (tester) async {
    final queries = <String>[];
    await tester.pumpWidget(harness(onSearch: queries.add));

    await tester.enterText(find.byType(TextField), 'dart');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    expect(queries, <String>['dart']);

    await tester.pump(const Duration(seconds: 1));
    expect(queries, <String>['dart']);
  });

  testWidgets('disabling the field cancels the pending callback',
      (tester) async {
    final queries = <String>[];
    await tester.pumpWidget(harness(onSearch: queries.add));
    await tester.enterText(find.byType(TextField), 'pending');

    await tester.pumpWidget(harness(onSearch: queries.add, enabled: false));
    await tester.pump(const Duration(seconds: 1));
    expect(queries, isEmpty);
  });

  testWidgets('external controller changes are debounced', (tester) async {
    final queries = <String>[];
    final controller = TextEditingController();
    await tester.pumpWidget(
      harness(onSearch: queries.add, controller: controller),
    );

    controller.text = 'external';
    await tester.pump(const Duration(milliseconds: 350));
    expect(queries, <String>['external']);

    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
  });

  testWidgets('disposing the widget cancels the pending callback',
      (tester) async {
    final queries = <String>[];
    await tester.pumpWidget(harness(onSearch: queries.add));
    await tester.enterText(find.byType(TextField), 'discard');

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    expect(queries, isEmpty);
  });

  testWidgets('zero debounce emits without waiting', (tester) async {
    final queries = <String>[];
    await tester.pumpWidget(harness(
      onSearch: queries.add,
      debounceDuration: Duration.zero,
    ));

    await tester.enterText(find.byType(TextField), 'now');
    expect(queries, <String>['now']);
  });

  testWidgets('repeating the same query does not call onSearch twice',
      (tester) async {
    final queries = <String>[];
    await tester.pumpWidget(harness(onSearch: queries.add));
    await tester.enterText(find.byType(TextField), 'same');
    await tester.pump(const Duration(milliseconds: 350));

    await tester.enterText(find.byType(TextField), 'sam');
    await tester.enterText(find.byType(TextField), 'same');
    await tester.pump(const Duration(milliseconds: 350));
    expect(queries, <String>['same']);
  });
}
