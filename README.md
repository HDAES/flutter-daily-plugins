# Flutter Daily Plugins 🚀

One lightweight, practical Flutter plugin or widget a day, with example apps, tests, and documentation.

每天一个轻量、实用的 Flutter 插件或组件。所有运行结果都以实际本地验证为准。

## Projects

| Day | Package | What it does | Status |
| --- | --- | --- | --- |
| 001 | [Guarded Async Button](day-001-guarded-async-button/) | Prevent repeated button taps while an async task is in progress | Source published; local verification pending |
| 002 | [OTP Cooldown Button](day-002-otp-cooldown-button/) | Prevent repeated OTP requests; countdown starts after a successful async send | Source published; local verification pending |
| 003 | [Debounced Search Field](day-003-debounced-search-field/) | Debounced input, immediate clear/submit, and search callbacks | Source published; local verification pending |
| 004 | [Password Strength Meter](day-004-password-strength-meter/) | Password rules, progress, and actionable feedback | Source published; local verification pending |
| 005 | [Masked Input Field](day-005-masked-input-field/) | Phone/card masks, paste support, and caret-aware editing | Source published; local verification pending |

## Quick start

```bash
cd day-001-guarded-async-button
flutter pub get
flutter analyze
flutter test
cd example
flutter create . --platforms=android,ios,web
flutter pub get
flutter run
```

The Day 001 project is a pure Flutter widget package, not a platform-channel plugin. iOS, Android, Web, and Flutter desktop are supported by the implementation; individual target builds still require verification.

## Repository structure

```text
flutter-daily-plugins/
├── README.md
├── LICENSE
├── day-001-guarded-async-button/
│   ├── lib/
│   ├── test/
│   ├── example/
│   ├── docs/x_publish_kit.md
│   └── README.md
├── day-002-otp-cooldown-button/
│   ├── lib/
│   ├── test/
│   ├── example/
│   ├── docs/x_publish_kit.md
│   └── README.md
├── day-003-debounced-search-field/
│   ├── lib/
│   ├── test/
│   ├── example/
│   ├── docs/x_publish_kit.md
│   └── README.md
├── day-004-password-strength-meter/
│   ├── lib/
│   ├── test/
│   ├── example/
│   ├── docs/x_publish_kit.md
│   └── README.md
└── day-005-masked-input-field/
    ├── lib/
    ├── test/
    ├── example/
    ├── docs/x_publish_kit.md
    └── README.md
```

## License

MIT — see [LICENSE](LICENSE). Code and examples are AI-assisted and should be reviewed and tested before production use.

## Daily publishing

The daily Flutter coding plan runs in ChatGPT (around 09:00 Beijing time), not GitHub Actions. The scheduled task is instructed to generate a package, attempt to push it through the connected GitHub integration, and verify the commit.

Direct GitHub publishing was first verified by the Day 003 scheduled task on 2026-10-26. Future runs can still fail; check the daily report for the actual commit URL or a clear upload-failure notice.

Run `flutter analyze`, `flutter test`, and the example app on your own machine before claiming validation or posting real screenshots on X. Unverified packages must be labeled accordingly.
