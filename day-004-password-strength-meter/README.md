# Day 004 — Password Strength Meter

A dependency-light Flutter **Widget** and pure-Dart evaluator for password rule feedback.

## Features

- Five visible checks: minimum length, ASCII lowercase, ASCII uppercase, digits, and symbols.
- Four qualitative labels (weak / fair / good / strong), plus an empty-input state.
- Linear rule-coverage progress; configurable minimum length (default 8).
- Optionally hide the label, checklist, or progress bar.
- No controller ownership, network requests, password persistence, or third-party runtime packages.
- Pure evaluator is independently testable; widget updates when its password property changes.

## Quick use

~~~dart
import 'package:password_strength_meter/password_strength_meter.dart';

PasswordStrengthMeter(
  password: currentPassword,
  minLength: 12,
)
~~~

Place it below a TextField and call setState in onChanged to pass the latest input.

## Local verification

Requires a local Flutter SDK and an enabled browser or device. **The commands below have not been executed on your machine.**

~~~bash
cd day-004-password-strength-meter
flutter pub get
flutter analyze
flutter test

cd example
flutter create . --platforms=android,ios,web
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
# Or: flutter run -d <device-id>
~~~

The example runner files are generated locally by flutter create. No native plugin, Android/iOS permission, server, or API key is required.

## Security and accessibility limitations

**This is a UI rule meter, not a security-grade password-strength estimator.** Rule coverage is not entropy or resistance to guessing. Short passwords remain labeled weak even when they contain several character classes. The progress bar displays the fraction of rules met, so it can be relatively full while the label is weak if the length requirement fails.

The sample policy uses ASCII-oriented character checks and Dart UTF-16 code-unit length; non-Latin scripts and Unicode grapheme length require a product-specific policy. The symbol rule counts non-ASCII non-whitespace characters as symbols; adapt it for internationalized applications. Real systems must apply server-side policy enforcement, breached-password screening, appropriate rate limiting, and secure password handling. Avoid logging or persisting raw passwords.

A semantics label is attached to the progress indicator; validate screen-reader behavior and contrast on your target devices before shipping.

## Status and license

**Source submitted; local Flutter analysis, tests, and real-device validation pending.** Included tests are test source, not evidence that they passed.

MIT License — see repository root LICENSE. AI-assisted code should be reviewed before production use.
