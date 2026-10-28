import 'package:flutter/material.dart';
import 'package:masked_input_field/masked_input_field.dart';

void main() => runApp(const MaskedInputDemo());

class MaskedInputDemo extends StatelessWidget {
  const MaskedInputDemo({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Masked Input Field',
        theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
        home: const MaskedInputDemoPage(),
      );
}

class MaskedInputDemoPage extends StatefulWidget {
  const MaskedInputDemoPage({super.key});

  @override
  State<MaskedInputDemoPage> createState() => _MaskedInputDemoPageState();
}

class _MaskedInputDemoPageState extends State<MaskedInputDemoPage> {
  String _phoneRaw = '';
  String _cardRaw = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Day 005 · Masked Input Field')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ListView(
              padding: const EdgeInsets.all(24),
              shrinkWrap: true,
              children: [
                const Text('输入掩码演示', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 16),
                MaskedInputField(
                  key: const Key('phone_field'),
                  mask: '### #### ####',
                  labelText: '手机号（11 位）',
                  hintText: '138 0013 8000',
                  keyboardType: TextInputType.phone,
                  onRawChanged: (value) =>
                      setState(() => _phoneRaw = value),
                ),
                const SizedBox(height: 8),
                Text('原始手机号：$_phoneRaw', key: const Key('phone_raw')),
                const SizedBox(height: 24),
                MaskedInputField(
                  key: const Key('card_field'),
                  mask: '#### #### #### #### ###',
                  labelText: '卡号（最多 19 位）',
                  hintText: '1234 5678 9012 3456',
                  keyboardType: TextInputType.number,
                  onRawChanged: (value) => setState(() => _cardRaw = value),
                ),
                const SizedBox(height: 8),
                Text('原始卡号：$_cardRaw', key: const Key('card_raw')),
                const SizedBox(height: 24),
                const Text(
                  '试试粘贴连续数字、移动光标到中间插入，'
                  '或在空格旁按退格键。输入掩码仅负责展示，'
                  '不验证手机号归属或银行卡有效性。',
                ),
              ],
            ),
          ),
        ),
      );
}
