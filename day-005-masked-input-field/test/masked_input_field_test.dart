import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masked_input_field/masked_input_field.dart';

void main() {
  testWidgets('field reports formatted and raw values', (tester) async {
    String? formatted;
    String? raw;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MaskedInputField(
          mask: '### ####',
          labelText: '号码',
          keyboardType: TextInputType.number,
          onChanged: (value) => formatted = value,
          onRawChanged: (value) => raw = value,
        ),
      ),
    ));

    await tester.enterText(find.byType(TextField), '1234567');
    await tester.pump();
    expect(formatted, '123 4567');
    expect(raw, '1234567');
    expect(find.text('123 4567'), findsOneWidget);
  });

  testWidgets('caller retains ownership of controller', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MaskedInputField(
          mask: '##-##',
          controller: controller,
        ),
      ),
    ));
    await tester.enterText(find.byType(TextField), '1234');
    await tester.pump();
    expect(controller.text, '12-34');
    await tester.pumpWidget(const SizedBox.shrink());
    expect(controller.text, '12-34');
  });
}
