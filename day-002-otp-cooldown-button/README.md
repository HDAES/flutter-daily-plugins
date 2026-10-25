# Day 002 · OTP Cooldown Button

一个用于**验证码发送 / 重发**场景的轻量 Flutter Widget：异步发送时锁定按钮；发送成功后启动倒计时；失败时恢复可点击。纯 Flutter 实现，无原生平台通道或运行时第三方依赖。

> 状态：**源码已生成，Flutter SDK 静态分析、Widget 测试和设备运行尚未执行**。请在本地验证后再公开报告结果。

## 功能与设计边界

- 首次点击立即锁定，避免请求期间重复触发。
- `onSend` 成功完成后才启动倒计时（默认 60 秒，可配置）。
- `onSend` 抛错时通过 `onError` 回调报告，并允许立即重试。
- 倒计时显示“XX 秒后重发”；支持自定义文案、按钮样式、启用状态。
- App 回到前台时用实际时间修正可能被后台暂停的倒计时。
- Widget 销毁时取消定时器；异步返回后检查 `mounted`。
- **限制：** 倒计时仅属于当前 Widget 的内存状态，重建或重新进入页面会重置；不跨进程持久化，也不能防止跨设备或恶意请求。服务端必须实现短信发送频控、验证码校验、风控及过期机制。

## 目录

```text
day-002-otp-cooldown-button/
├── lib/
│   ├── otp_cooldown_button.dart
│   └── src/otp_cooldown_button.dart
├── test/otp_cooldown_button_test.dart
├── example/
│   ├── lib/main.dart
│   ├── test/widget_test.dart
│   └── pubspec.yaml
├── docs/x_publish_kit.md
├── pubspec.yaml
├── analysis_options.yaml
├── CHANGELOG.md
└── LICENSE
```

## 使用

将本目录加入 Flutter 项目，以本地路径依赖方式使用：

```yaml
dependencies:
  flutter:
    sdk: flutter
  otp_cooldown_button:
    path: ../day-002-otp-cooldown-button
```

```dart
import 'package:otp_cooldown_button/otp_cooldown_button.dart';

OtpCooldownButton(
  cooldownSeconds: 60,
  onSend: () async {
    await sendOtpFromYourBackend(); // 替换成你自己的 API
  },
  onError: (error, stackTrace) {
    // 展示错误信息 / 记录日志
  },
)
```

`onSend` **必须在失败时抛出异常**，组件才能区分发送成功与失败。成功回调结束后才开始计时。自定义文案可传入 `countdownLabelBuilder: (s) => '重发 ($s s)'`。

## 本地运行与验证

要求：Flutter SDK（Dart >= 3.3），可用的 Flutter 环境；无需额外原生权限。

```bash
cd day-002-otp-cooldown-button
flutter pub get
dart format --output=none --set-exit-if-changed lib test example/lib example/test
flutter analyze
flutter test

cd example
flutter create . --platforms=android,ios,web
flutter pub get
flutter run
flutter test
```

若格式检查失败，先运行 `dart format lib test example/lib example/test` 再重新检查。也可以运行 `flutter run -d chrome` 体验 Web 演示。

## 手动验证清单

1. 关闭“模拟失败”，连续快速点击按钮，确认请求计数只加 1。
2. 观察按钮先显示“发送中…”，再显示 10 秒倒计时。
3. 倒计时期间点击按钮，确认请求数不变；归零后可重发。
4. 打开“模拟失败”，确认错误提示出现、没有进入倒计时且可以立即重试。
5. 将 App 置于后台超过 10 秒再回到前台，确认倒计时按实际经过时间恢复或结束（需设备验证）。

## 平台限制

- iOS / Android / Web / macOS / Windows / Linux：代码使用 Flutter 标准 Widget 和 Dart Timer，设计上不依赖平台 API；**实际平台运行尚待验证**。
- iOS 运行需要 macOS + Xcode 和适当的模拟器/签名环境；Android 需要 Android SDK 和模拟器/真机。
- 本项目**不发送真实短信**，不需要短信权限。真实发送应调用后端 HTTPS API，而非直接把短信服务密钥写入客户端。

## GitHub 提交建议

```bash
git add day-002-otp-cooldown-button
git commit -m "feat(day-002): add OTP cooldown button and widget tests"
```

本项目遵循 MIT License（仓库根目录与本目录均有许可证文本）。