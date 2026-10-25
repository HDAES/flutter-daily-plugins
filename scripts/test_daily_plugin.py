import datetime as dt
import tempfile
import unittest
from pathlib import Path

from daily_plugin import (
    Item,
    resolve_day,
    update_index,
    update_roadmap,
    validate_content,
    package_files,
)


class WorkflowContractTests(unittest.TestCase):
    def setUp(self):
        self.item = Item(3, 'Debounced Search Field', 'debounced_search_field', '输入防抖', 'Widget')

    def test_day_offset_in_china(self):
        at = dt.datetime(2026, 10, 26, 1, 17, tzinfo=dt.timezone.utc)
        self.assertEqual(resolve_day('', at), 3)
        self.assertEqual(resolve_day('005', at), 5)

    def test_repo_index_idempotent(self):
        old = '# Widgets\n\n| Day | Project | Detail | Status |\n|---|---|---|---|\n| 001 | A | X | done |\n| 002 | B | Y | done |\n'
        new = update_index(old, self.item)
        self.assertIn('| 003 | [Debounced Search Field]', new)
        self.assertEqual(update_index(new, self.item), new)

    def test_roadmap_does_not_fake_local_validation(self):
        roadmap = '| 003 | **Debounced Search Field** · `debounced_search_field` | 输入防抖 | Widget | ★ | ⬜ 计划中 |\n'
        new = update_roadmap(roadmap, self.item)
        self.assertIn('📦 已提交（待本地验证）', new)
        self.assertEqual(update_roadmap(new, self.item), new)

    def test_reject_unknown_dependency_import(self):
        files = {'implementation': 'class Example {}\nimport "package:http/http.dart";\n',
                 'tests': 'void main() { testWidgets("a", (tester) {}); }\n' * 5,
                 'example': 'void main() { runApp(const DemoApp()); }\n' * 5,
                 'readme': 'README ' * 25,
                 'x_publish_kit': 'Draft ' * 30}
        with self.assertRaises(ValueError):
            validate_content(self.item, files)

    def test_paths_are_fixed_and_pubspec_is_synthesized(self):
        files = package_files(self.item, {
            'implementation': 'class DebouncedSearchField {}',
            'tests': 'void main() {}',
            'example': 'void main() {}',
            'readme': '# README',
            'x_publish_kit': '# X',
        }, 'MIT License\n')
        self.assertIn('lib/src/debounced_search_field.dart', files)
        self.assertIn('package: flutter', files['pubspec.yaml'].replace('  flutter:', 'package: flutter'))
        self.assertIn('MIT License', files['LICENSE'])
        self.assertEqual(len(files), 12)


if __name__ == '__main__':
    unittest.main()