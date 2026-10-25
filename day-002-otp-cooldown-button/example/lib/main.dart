import 'package:flutter/material.dart';
import 'package:otp_cooldown_button/otp_cooldown_button.dart';

void main() => runApp(const OtpDemoApp());

class OtpDemoApp extends StatelessWidget {
  const OtpDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Day 002 · OTP Cooldown',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const OtpDemoPage(),
    );
  }
}

class OtpDemoPage extends StatefulWidget {
  const OtpDemoPage({super.key});

  @override
  State<OtpDemoPage> createState() => _OtpDemoPageState();
}

class _OtpDemoPageState extends State<OtpDemoPage> {
  bool _simulateFailure = false;
  int _requests = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Day 002 · 验证码倒计时')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('模拟发送验证码：成功后倒计时 10 秒，失败可立即重试。'),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('模拟服务端发送失败'),
              value: _simulateFailure,
              onChanged: (value) => setState(() => _simulateFailure = value),
            ),
            const SizedBox(height: 12),
            OtpCooldownButton(
              cooldownSeconds: 10,
              onSend: () async {
                setState(() => _requests++);
                await Future<void>.delayed(const Duration(milliseconds: 700));
                if (_simulateFailure) throw StateError('模拟发送失败');
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('模拟发送成功（没有真实短信）')),
                );
              },
              onError: (error, _) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('发送失败：$error')),
                );
              },
            ),
            const SizedBox(height: 24),
            Text('请求次数：$_requests'),
            const SizedBox(height: 12),
            const Text('演示仅模拟请求。真实验证码需服务端限流、有效期与风控。'),
          ],
        ),
      ),
    );
  }
}
