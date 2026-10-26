# Day 003 — Debounced Search Field

A dependency-light Flutter **Widget** that turns rapid input into one search callback. Includes a clear button, keyboard submit, and external controller support.

## Features

- Debounces text changes (350 ms by default; configurable, including zero).
- Emits the final query through `onSearch(String query)`; optional `onChanged` fires for each edit.
- Tapping Clear immediately emits an empty query and cancels the pending timer.
- Pressing the keyboard Search action immediately emits the query and cancels the timer.
- Suppresses consecutive identical search callbacks.
- Supports a caller-owned `TextEditingController` and `FocusNode`.
- Cancels timers on disable, configuration changes, controller replacement, and dispose.
- Does **not** automatically search on mount, even when the external controller has initial text.

## Quick use

```dart
import 'package:debounced_search_field/debounced_search_field.dart';

DebouncedSearchField(
  debounceDuration: const Duration(milliseconds: 400),
  hintText: 'Search items',
  onSearch: (query) {
    // Send the query to your repository, API, or local filter.
  },
)
```

## Local verification (you run these commands)

Prerequisites: Flutter SDK and an enabled target device or browser.

```bash
cd day-003-debounced-search-field
flutter pub get
flutter analyze
flutter test

cd example
flutter create . --platforms=android,ios,web
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
# Or: flutter run -d <your-device-id>
```

The example uses **local in-memory data**, not an API or SMS service. `flutter create .` creates platform scaffolding for the demo; the package itself is a pure Flutter widget with no platform channels.

## Behavioral contract

| Action | Result |
| --- | --- |
| Type `f`, then `fl` before the timer expires | One `onSearch('fl')` after the final pause |
| Tap clear icon | Immediate `onSearch('')` and `onCleared` |
| Press keyboard Search | Immediate `onSearch(currentText)` |
| Type the same query again | No duplicate `onSearch` |
| Disable/dispose/replace controller | Pending timer is canceled |

`onSearch` is a synchronous callback. If it launches asynchronous HTTP requests, **you** must guard against out-of-order responses and enforce server-side limits; this widget only debounces input events. Programmatic changes to an external controller also trigger the debounce. Whitespace and case are preserved in callbacks; normalization is the caller's responsibility.

## Status and license

**Source submitted; local Flutter analysis, widget tests, and device runs are pending.** Do not treat these instructions or included tests as evidence that they have passed.

MIT License — see the repository root `LICENSE`. AI-assisted source should be reviewed before production use.
