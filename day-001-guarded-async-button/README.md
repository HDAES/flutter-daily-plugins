# Day 001 · Guarded Async Button

一个**纯 Flutter Widget 组件包**（不是需要原生平台通道的插件），在异步请求执行期间自动禁用按钮，防止同一按钮被重复点击。适合表单提交、订单确认、文件上传触发等场景。

## 功能

- 首次点击后立即进入 loading 状态，直到 Future 完成。
- 异步期间禁用按钮，避免同一个 Widget 实例内的重复触发。
- 支持自定义按钮文字、loading 文字、样式和错误回调。
- 请求成功或失败后恢复可点击状态；组件销毁后不会再 setState。
- 不依赖第三方运行时包，可用于 iOS、Android、Web、桌面 Flutter（待平台实测）。

**边界：** 只能阻止客户端同一按钮实例的连续点击，不能防止网络重试、多个设备或重复订单。涉及支付/订单/写操作时，后端仍需幂等键与约束。

## 目录

```text
lib/guarded_async_button.dart         对外导出
lib/src/guarded_async_button.dart     核心组件
test/guarded_async_button_test.dart   Widget 测试
example/lib/main.dart                 可运行演示源代码
example/pubspec.yaml                  演示依赖
docs/x_publish_kit.md                 X 发布素材包
```

## 依赖

本包 `pubspec.yaml` 使用 Dart `>=3.3.0 <4.0.0`，仅依赖 Flutter SDK。将本目录放入你的项目后，可使用本地 path 依赖：

```yaml
dependencies:
  flutter:
    sdk: flutter
  guarded_async_button:
    path: ../day-001-guarded-async-button
```

## 使用

```dart
import 'package:guarded_async_button/guarded_async_button.dart';

GuardedAsyncButton(
  label: '保存',
  loadingLabel: '保存中…',
  onPressed: () async {
    await saveData(); // 换成你的实际异步函数
  },
  onError: (error, stackTrace) {
    // 在此显示错误提示或上报日志
  },
)
```

## 本地验证

需要安装 Flutter SDK，确保 `flutter doctor` 正常。项目根目录执行：

```bash
flutter pub get
dart format lib test example/lib
flutter analyze
flutter test
```

运行演示（首次生成 Android/iOS/Web 平台脚手架）：

```bash
cd example
flutter create . --platforms=android,ios,web
flutter pub get
flutter run
```

> macOS 上构建 iOS 还需 Xcode、CocoaPods 和相应签名配置。Android 需 Android SDK/模拟器或真机。Web 需 Chrome 或其他受支持浏览器。该组件不调用原生 API，无额外权限或平台通道配置。

## 测试清单

1. 快速点击按钮多次，pending 期间只调用一次回调。
2. loading 时按钮禁用，Future 完成后恢复。
3. Future 抛错时触发 `onError`，随后恢复可点击。
4. `enabled: false` 时不执行回调。
5. 组件被移除后异步完成，不出现 setState-after-dispose。

**验证状态：待本地执行。** 此次提交没有运行 `flutter analyze`、`flutter test` 或模拟器演示；请勿把测试写成“已通过”。

## License

MIT，详见仓库根目录 [LICENSE](../LICENSE)。
