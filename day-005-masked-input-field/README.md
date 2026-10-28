# Day 005 — Masked Input Field

A small Flutter **Widget** and `TextInputFormatter` for phone/card-style input masks, including caret-aware insertion and deletion around separators.

## Features

- `#` = ASCII digit; `A` = ASCII letter; `*` = ASCII letter or digit.
- Literal punctuation/whitespace separators are inserted only when a following token is present.
- Paste raw or formatted input; invalid characters are ignored; overflow is truncated.
- Maps collapsed caret and selection ranges through formatting; backspace/forward-delete over a separator removes an adjacent token instead of trapping the cursor.
- `onChanged` returns formatted text; `onRawChanged` returns unmasked text.
- No network calls, native dependencies, permissions, or runtime packages beyond Flutter.

## Quick use

```dart
import 'package:flutter/material.dart';
import 'package:masked_input_field/masked_input_field.dart';

MaskedInputField(
  mask: '### #### ####',
  labelText: '手机号',
  keyboardType: TextInputType.phone,
  onRawChanged: (digits) => debugPrint('length: ${digits.length}'),
)
```

For a card-style mask, use `#### #### #### #### ###` (up to 19 digits). For alphanumeric IDs, use `AA-####`. The underlying `MaskedInputFormatter` can be attached directly to any `TextField` via `inputFormatters`.

## Local verification

The commands below are **instructions, not verified execution results**. Run them after pulling the repo:

```bash
git pull origin main
cd day-005-masked-input-field
flutter pub get
flutter analyze
flutter test
cd example
flutter create . --platforms=android,ios,web
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
# Alternatively: flutter devices && flutter run -d <device-id>
```

`flutter create .` adds platform runners to the minimal example; do not overwrite source code if prompted. Try paste, insert in the middle, select/replace, backspace at a separator, and forward-delete at a separator on your target devices.

## Constraints and production notes

- **Presentation only**: formatting does not validate a phone number, bank-card checksum (Luhn), issuer, length requirements, or payment security. Perform server-side validation and do not log real card data.
- Masks use ASCII token classes; Unicode digits/letters are ignored. Literal letters/digits are not supported because they are ambiguous with editable tokens. Only punctuation/whitespace should be used as separators.
- Mask length is fixed; no variable-length mask, prefix switching, international phone number parsing, or card-type inference.
- Active IME composition is left untouched until composition ends. Test IME, accessibility, selection, copy/paste, and device keyboards before production use.
- Programmatic changes to a `TextEditingController.text` bypass input formatters. Format initial values yourself or pass edits through the formatter.
- The included tests are source code, not evidence of successful Flutter execution. Local analysis, tests, and device checks are pending.

MIT License — see repository root `LICENSE`. AI-assisted code requires review before production use.
