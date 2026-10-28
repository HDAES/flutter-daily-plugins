import 'package:flutter/services.dart';

/// Formats ASCII input using a fixed mask while keeping the caret near edits.
///
/// Tokens: '#' = digit, 'A' = ASCII letter, '*' = ASCII letter or digit.
/// Other characters in [mask] are fixed separators. Use punctuation and
/// whitespace as separators (not letters/digits). Examples:
/// '### #### ####', '#### #### #### #### ###', 'AA-####'.
///
/// This is presentation-only; validate the unmasked value on the server.
class MaskedInputFormatter extends TextInputFormatter {
  MaskedInputFormatter({required this.mask}) {
    if (mask.isEmpty || !mask.split('').any(_isToken)) {
      throw ArgumentError.value(mask, 'mask', 'Must contain at least one token');
    }
    for (final character in mask.split('')) {
      if (!_isToken(character) && _isAsciiAlphanumeric(character)) {
        throw ArgumentError.value(
          mask,
          'mask',
          'Literal letters/digits are unsupported; use punctuation separators',
        );
      }
    }
  }

  final String mask;

  static bool _isToken(String character) =>
      character == '#' || character == 'A' || character == '*';

  static bool _isAsciiDigit(String character) =>
      RegExp(r'^[0-9]$').hasMatch(character);

  static bool _isAsciiLetter(String character) =>
      RegExp(r'^[A-Za-z]$').hasMatch(character);

  static bool _isAsciiAlphanumeric(String character) =>
      _isAsciiDigit(character) || _isAsciiLetter(character);

  static bool _accepts(String token, String character) => switch (token) {
        '#' => _isAsciiDigit(character),
        'A' => _isAsciiLetter(character),
        '*' => _isAsciiAlphanumeric(character),
        _ => false,
      };

  List<String> get _tokens => mask.split('').where(_isToken).toList();

  /// Extracts only the characters accepted by successive mask slots.
  /// Non-ASCII digits/letters and separators are intentionally discarded.
  String unmask(String text) {
    final tokens = _tokens;
    final raw = StringBuffer();
    var slot = 0;
    for (final rune in text.runes) {
      if (slot == tokens.length) break;
      final character = String.fromCharCode(rune);
      if (_accepts(tokens[slot], character)) {
        raw.write(character);
        slot++;
      }
    }
    return raw.toString();
  }

  int _clampOffset(int offset, int length) {
    if (offset < 0) return length;
    if (offset > length) return length;
    return offset;
  }

  int _rawOffset(String text, int offset) =>
      unmask(text.substring(0, _clampOffset(offset, text.length))).length;

  /// Returns the removed index only for a single-character deletion.
  int? _deletedIndex(TextEditingValue oldValue, TextEditingValue newValue) {
    final oldText = oldValue.text;
    final newText = newValue.text;
    if (oldText.length != newText.length + 1 ||
        !oldValue.selection.isCollapsed ||
        !newValue.selection.isCollapsed) {
      return null;
    }
    final index = _clampOffset(newValue.selection.extentOffset, newText.length);
    if (oldText.substring(0, index) == newText.substring(0, index) &&
        oldText.substring(index + 1) == newText.substring(index)) {
      return index;
    }
    return null;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Flutter recommends not modifying text during active IME composition.
    if (!newValue.composing.isCollapsed) return newValue;

    var raw = unmask(newValue.text);
    var base = _rawOffset(newValue.text, newValue.selection.baseOffset);
    var extent = _rawOffset(newValue.text, newValue.selection.extentOffset);

    // Backspace/delete on a visual separator should delete an adjacent token,
    // rather than silently restoring the separator and trapping the caret.
    final deleted = _deletedIndex(oldValue, newValue);
    if (deleted != null &&
        !_isAsciiAlphanumeric(oldValue.text[deleted]) &&
        unmask(oldValue.text) == raw) {
      final preceding = _rawOffset(oldValue.text, deleted);
      final caret = oldValue.selection.extentOffset;
      final removeAt = caret == deleted + 1
          ? preceding - 1 // backspace
          : caret == deleted
              ? preceding // forward delete
              : -1;
      if (removeAt >= 0 && removeAt < raw.length) {
        raw = raw.replaceRange(removeAt, removeAt + 1, '');
        base = removeAt;
        extent = removeAt;
      }
    }

    final output = StringBuffer();
    final positions = <int>[0];
    var rawIndex = 0;
    for (final character in mask.split('')) {
      if (_isToken(character)) {
        if (rawIndex == raw.length) break;
        output.write(raw[rawIndex]);
        rawIndex++;
        positions.add(output.length);
      } else if (rawIndex < raw.length) {
        // Do not leave trailing separators in the displayed value.
        output.write(character);
      }
    }
    final formatted = output.toString();
    final maxCount = positions.length - 1;
    final safeBase = base < 0 ? 0 : (base > maxCount ? maxCount : base);
    final safeExtent =
        extent < 0 ? 0 : (extent > maxCount ? maxCount : extent);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection(
        baseOffset: positions[safeBase],
        extentOffset: positions[safeExtent],
        affinity: newValue.selection.affinity,
        isDirectional: newValue.selection.isDirectional,
      ),
    );
  }
}
