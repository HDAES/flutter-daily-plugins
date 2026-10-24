# Flutter Daily Plugins 🚀

One lightweight, practical Flutter plugin or widget a day, with example apps, tests, and documentation.

每天一个轻量、实用的 Flutter 插件或组件。所有运行结果都以实际本地验证为准。

## Projects

| Day | Package | What it does | Status |
| --- | --- | --- | --- |
| 001 | [Guarded Async Button](day-001-guarded-async-button/) | Prevent repeated button taps while an async task is in progress | Source published; local verification pending |

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
└── day-001-guarded-async-button/
    ├── lib/
    ├── test/
    ├── example/
    ├── docs/x_publish_kit.md
    └── README.md
```

## License

MIT — see [LICENSE](LICENSE). Code and examples are AI-assisted and should be reviewed and tested before production use.
