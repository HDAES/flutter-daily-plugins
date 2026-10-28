import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:masked_input_field_example/main.dart';

void main() {
  testWidgets('demo exposes phone and card fields', (tester) async {
    await tester.pumpWidget(const MaskedInputDemo());
    expect(find.byKey(const Key('phone_field')), findsOneWidget);
    expect(find.byKey(const Key('card_field')), findsOneWidget);
    expect(find.text('原始手机号：'), findsOneWidget);
    expect(find.text('原始卡号：'), findsOneWidget);
  });
}
