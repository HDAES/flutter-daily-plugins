import 'package:flutter/material.dart';
import 'package:password_strength_meter/password_strength_meter.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Strength Meter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const PasswordDemoPage(),
    );
  }
}

class PasswordDemoPage extends StatefulWidget {
  const PasswordDemoPage({super.key});

  @override
  State<PasswordDemoPage> createState() => _PasswordDemoPageState();
}

class _PasswordDemoPageState extends State<PasswordDemoPage> {
  String _password = '';
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Day 004 · Password Strength Meter')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: ListView(
              padding: const EdgeInsets.all(24),
              shrinkWrap: true,
              children: [
                const Text('创建密码', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 16),
                TextField(
                  key: const Key('password_input'),
                  obscureText: _obscured,
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (value) => setState(() => _password = value),
                  decoration: InputDecoration(
                    labelText: '密码',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      tooltip: _obscured ? '显示密码' : '隐藏密码',
                      onPressed: () => setState(() => _obscured = !_obscured),
                      icon: Icon(
                        _obscured ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                PasswordStrengthMeter(password: _password, minLength: 8),
                const SizedBox(height: 20),
                const Text(
                  '演示说明：强度条只表示满足了多少条规则，不代表密码实际安全性。'
                  '真实产品仍需服务端校验和泄露密码检测。',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
