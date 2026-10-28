import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masked_input_field/masked_input_field.dart';

TextEditingValue value(String text, {int? cursor, int? end}) =>
    TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: cursor ?? text.length,
        extentOffset: end ?? cursor ?? text.length,
      ),
    );

void main() {
  group('MaskedInputFormatter', () {
    final phone = MaskedInputFormatter(mask: '### #### ####');

    test('formats pasted digits without trailing separators', () {
      final result = phone.formatEditUpdate(
        TextEditingValue.empty,
        value('13800138000'),
      );
      expect(result.text, '138 0013 8000');
      expect(result.selection.extentOffset, result.text.length);
      expect(phone.formatEditUpdate(TextEditingValue.empty, value('138')).text,
          '138');
    });

    test('preserves already formatted input', () {
      final result = phone.formatEditUpdate(
        TextEditingValue.empty,
        value('138 0013 8000'),
      );
      expect(result.text, '138 0013 8000');
      expect(phone.unmask(result.text), '13800138000');
    });

    test('rejects punctuation and non-ASCII digits', () {
      final result = phone.formatEditUpdate(
        TextEditingValue.empty,
        value('1x3-8 ٠01'),
      );
      expect(result.text, '138 01');
    });

    test('truncates beyond mask capacity', () {
      final result = phone.formatEditUpdate(
        TextEditingValue.empty,
        value('123456789012345'),
      );
      expect(result.text, '123 4567 8901');
      expect(result.selection.extentOffset, result.text.length);
    });

    test('mid-string insertion retains caret after inserted digit', () {
      final result = phone.formatEditUpdate(
        value('123 456', cursor: 4),
        value('123 9456', cursor: 5),
      );
      expect(result.text, '123 9456');
      expect(result.selection.extentOffset, 5);
    });

    test('backspace on separator removes preceding digit', () {
      final result = phone.formatEditUpdate(
        value('123 456', cursor: 4),
        value('123456', cursor: 3),
      );
      expect(result.text, '124 56');
      expect(result.selection.extentOffset, 2);
    });

    test('forward delete on separator removes next digit', () {
      final result = phone.formatEditUpdate(
        value('123 456', cursor: 3),
        value('123456', cursor: 3),
      );
      expect(result.text, '123 56');
      expect(result.selection.extentOffset, 3);
    });

    test('selection range is mapped around separators', () {
      final result = phone.formatEditUpdate(
        TextEditingValue.empty,
        value('123456', cursor: 2, end: 5),
      );
      expect(result.text, '123 456');
      expect(result.selection.baseOffset, 2);
      expect(result.selection.extentOffset, 6);
    });

    test('does not modify composing IME text', () {
      final input = TextEditingValue(
        text: '1234',
        selection: const TextSelection.collapsed(offset: 4),
        composing: const TextRange(start: 0, end: 4),
      );
      expect(phone.formatEditUpdate(TextEditingValue.empty, input), input);
    });

    test('mixed letter and digit tokens', () {
      final formatter = MaskedInputFormatter(mask: 'AA-##-**');
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        value('aB12z9'),
      );
      expect(result.text, 'aB-12-z9');
      expect(formatter.unmask(result.text), 'aB12z9');
    });

    test('rejects invalid masks', () {
      expect(() => MaskedInputFormatter(mask: ''), throwsArgumentError);
      expect(() => MaskedInputFormatter(mask: '--'), throwsArgumentError);
      expect(() => MaskedInputFormatter(mask: 'tel-###'), throwsArgumentError);
    });
  });
}
