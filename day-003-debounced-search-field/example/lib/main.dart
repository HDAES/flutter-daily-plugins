import 'package:flutter/material.dart';
import 'package:debounced_search_field/debounced_search_field.dart';

void main() => runApp(const DebouncedSearchDemoApp());

class DebouncedSearchDemoApp extends StatelessWidget {
  const DebouncedSearchDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Day 003 · Debounced Search',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const SearchDemoPage(),
    );
  }
}

class SearchDemoPage extends StatefulWidget {
  const SearchDemoPage({super.key});

  @override
  State<SearchDemoPage> createState() => _SearchDemoPageState();
}

class _SearchDemoPageState extends State<SearchDemoPage> {
  static const _items = <String>[
    'Flutter Widgets',
    'Dart Collections',
    'Search UX',
    'Material Design',
    'State Management',
    'Debounce Patterns',
  ];

  List<String> _results = List<String>.of(_items);
  String _lastQuery = '';
  int _searchCount = 0;

  void _search(String query) {
    final needle = query.trim().toLowerCase();
    setState(() {
      _searchCount++;
      _lastQuery = query;
      _results = _items
          .where((item) => item.toLowerCase().contains(needle))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Day 003 · 搜索防抖')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('连续输入会合并为一次搜索；点击清除或键盘搜索键立即执行。'),
            const SizedBox(height: 16),
            DebouncedSearchField(
              onSearch: _search,
              debounceDuration: const Duration(milliseconds: 400),
              hintText: '搜索 Flutter、Dart、UX…',
              clearTooltip: '清除搜索',
            ),
            const SizedBox(height: 16),
            Text('触发搜索次数：' + _searchCount.toString()),
            Text('最近搜索：' + (_lastQuery.isEmpty ? '全部' : _lastQuery)),
            const SizedBox(height: 12),
            Expanded(
              child: _results.isEmpty
                  ? const Center(child: Text('没有匹配结果'))
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: const Icon(Icons.article_outlined),
                        title: Text(_results[index]),
                      ),
                    ),
            ),
            const Text('仅过滤本地模拟数据；未调用真实搜索 API。'),
          ],
        ),
      ),
    );
  }
}
