import 'package:flutter/material.dart';
import 'package:guarded_async_button/guarded_async_button.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guarded Async Button',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int _requests = 0;
  bool _simulateError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Day 001 · 防重复点击按钮')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('快速连续点击提交，观察请求次数是否只增加 1。'),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('模拟接口失败'),
              value: _simulateError,
              onChanged: (value) => setState(() => _simulateError = value),
            ),
            const SizedBox(height: 12),
            GuardedAsyncButton(
              label: '提交订单',
              loadingLabel: '提交中…',
              onPressed: () async {
                setState(() => _requests++);
                await Future<void>.delayed(const Duration(seconds: 2));
                if (_simulateError) throw StateError('模拟网络失败');
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('提交完成')),
                );
              },
              onError: (error, _) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('失败：$error')),
                );
              },
            ),
            const SizedBox(height: 24),
            Text('请求次数：$_requests'),
            const SizedBox(height: 12),
            const Text('注意：UI 防重复点击不能替代后端幂等校验。'),
          ],
        ),
      ),
    );
  }
}
