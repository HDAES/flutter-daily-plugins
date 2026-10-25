#!/usr/bin/env python3
"""Plan, generate and index small Flutter packages from ROADMAP.md.

Generation calls the OpenAI Responses API. API credentials never belong in Git.
"""
from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import sys
import urllib.error
import urllib.request
from dataclasses import dataclass
from pathlib import Path
from zoneinfo import ZoneInfo

START_DATE = dt.date(2026, 10, 24)
TIMEZONE = ZoneInfo("Asia/Shanghai")
ROW_RE = re.compile(r"^\|\s*(\d{3})\s*\|\s*\*\*(.+?)\*\*\s*·\s*`([a-z][a-z0-9_]*)`\s*\|\s*(.+?)\s*\|\s*([^|]+)\|", re.M)
ALLOWED_IMPORTS = re.compile(r"^\s*import\s+['\"](.*?)['\"]", re.M)


@dataclass(frozen=True)
class Item:
    day: int
    title: str
    package: str
    description: str
    kind: str

    @property
    def folder(self) -> str:
        return f"day-{self.day:03d}-{self.package.replace('_', '-')}"


def read_roadmap(path: Path) -> dict[int, Item]:
    content = path.read_text(encoding="utf-8")
    items: dict[int, Item] = {}
    for match in ROW_RE.finditer(content):
        day, title, package, description, kind = match.groups()
        n = int(day)
        if n in items:
            raise ValueError(f"Duplicate Day {n:03d}")
        items[n] = Item(n, title.strip(), package, description.strip(), kind.strip())
    if sorted(items) != list(range(1, 101)):
        raise ValueError("ROADMAP.md must contain all 100 consecutive Day entries")
    return items


def resolve_day(requested: str, now: dt.datetime | None = None) -> int:
    if requested.strip():
        if not re.fullmatch(r"\d{1,3}", requested.strip()):
            raise ValueError("Manual day must be an integer from 1 to 100")
        return int(requested)
    now = now or dt.datetime.now(TIMEZONE)
    return (now.astimezone(TIMEZONE).date() - START_DATE).days + 1


def item_for_day(roadmap: Path, day: int) -> Item:
    if not 1 <= day <= 100:
        raise ValueError(f"Day {day} is outside the 100-day plan")
    return read_roadmap(roadmap)[day]


def output_github(path: str, values: dict[str, str]) -> None:
    if path:
        with open(path, "a", encoding="utf-8") as handle:
            for key, val in values.items():
                if "\n" in val or "\r" in val:
                    raise ValueError("Invalid GitHub output value")
                handle.write(f"{key}={val}\n")


def cmd_plan(args: argparse.Namespace) -> None:
    items = read_roadmap(args.roadmap)
    day = resolve_day(args.day)
    if day > 100:
        print("Flutter 100-day plan is complete; nothing to generate.")
        output_github(args.github_output, {"should_run": "false", "day": "", "target": ""})
        return
    if day < 2:
        print("Day 001 already exists; scheduled generation begins on Day 002.")
        output_github(args.github_output, {"should_run": "false", "day": "", "target": ""})
        return
    item = items[day]
    # Only check under root; do not overwrite manually committed projects.
    exists = (args.repository_root / item.folder).exists()
    output_github(args.github_output, {
        "should_run": "false" if exists else "true",
        "day": f"{day:03d}",
        "target": item.folder,
    })
    print(f"Day {day:03d}: {item.title} ({item.package}), exists={exists}")


def ask_model(item: Item, model: str) -> dict[str, str]:
    key = os.environ.get("OPENAI_API_KEY", "").strip()
    if not key:
        raise RuntimeError(
            "OPENAI_API_KEY is not configured. Add it under GitHub repository "
            "Settings -> Secrets and variables -> Actions -> New repository secret."
        )
    fields = ("implementation", "tests", "example", "readme", "x_publish_kit")
    schema = {
        "type": "object",
        "properties": {name: {"type": "string"} for name in fields},
        "required": list(fields),
        "additionalProperties": False,
    }
    instructions = (
        "You are an exacting Flutter/Dart engineer writing a small, independently usable "
        "open-source package. Respond ONLY in the JSON schema. Every field must contain "
        "the COMPLETE file contents, not markdown code fences. Prefer pure Flutter SDK "
        "and dart:* libraries; imports must use Flutter, flutter_test or this package. "
        "Provide a tested-in-principle MINIMAL implementation, do not invent runtime "
        "results. The implementation is stored at lib/src/<package>.dart and re-exported "
        "by lib/<package>.dart. Tests go to test/<package>_test.dart, import the package "
        "public export, and must work with flutter test. Example code goes to "
        "example/lib/main.dart and MUST declare `class DemoApp extends StatelessWidget` "
        "or `class DemoApp extends StatefulWidget`, plus void main() that runs DemoApp. "
        "The example must import the public package export. Do not access real network "
        "services, keys, contacts or phone hardware. For projects needing platform "
        "integration use injected callbacks and explain real limitations, not a fake "
        "native implementation. Write informative Chinese README and X post with no "
        "claims of running code or testing successfully. No remote scripts or dependencies. "
        "Handle lifecycle/dispose for controllers and timers; avoid flaky long-running "
        "tests. Provide 2-4 meaningful Widget or unit tests. X kit must contain a natural "
        "short Chinese post, 2-3 REAL screenshot suggestions, demo video scenario, "
        "technical summary, and a truthfully blank verification form with env, steps, "
        "expected, actual, bugs, fixes, GitHub link. Be original and keep code compact."
    )
    task = (
        f"Roadmap Day {item.day:03d}: {item.title}, package {item.package}, "
        f"category {item.kind}. Goal: {item.description}.\n"
        "Target Flutter stable/Dart SDK >=3.3.0. No third-party runtime dependencies. "
        "Implement meaningful demo UI and tests. Make sure constructors, imports, "
        "generic signatures and public API agree. README install should use local path "
        f"to day-{item.day:03d}-{item.package.replace('_', '-')}, commands should be "
        "flutter pub get / dart format / flutter analyze / flutter test, example "
        "flutter create . --platforms=android,ios,web. Mention platform restrictions "
        "where needed. GitHub repository HDAES/flutter-daily-plugins."
    )
    payload = {
        "model": model,
        "instructions": instructions,
        "input": task,
        "max_output_tokens": 16000,
        "text": {
            "format": {
                "type": "json_schema",
                "name": "flutter_daily_files",
                "strict": True,
                "schema": schema,
            }
        },
    }
    request = urllib.request.Request(
        "https://api.openai.com/v1/responses",
        data=json.dumps(payload, ensure_ascii=False).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {key}",
            "Content-Type": "application/json",
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(request, timeout=300) as response:
            reply = json.load(response)
    except urllib.error.HTTPError as err:
        # Never echo request headers or API key.
        raise RuntimeError(f"OpenAI API returned HTTP {err.code}; check key, billing and model") from None
    except urllib.error.URLError as err:
        raise RuntimeError(f"OpenAI API connection failed: {err.reason}") from None
    if reply.get("status") != "completed":
        raise RuntimeError(f"OpenAI response incomplete (status={reply.get('status')})")
    texts = [block.get("text", "")
             for output in reply.get("output", []) if output.get("type") == "message"
             for block in output.get("content", []) if block.get("type") == "output_text"]
    if not texts:
        raise RuntimeError("OpenAI API did not return output_text")
    result = json.loads("".join(texts))
    if set(result) != set(fields) or any(not isinstance(result[name], str) for name in fields):
        raise ValueError("Model response does not match expected files")
    return result


def validate_content(item: Item, result: dict[str, str]) -> None:
    for name, content in result.items():
        if not 120 <= len(content) <= 100_000:
            raise ValueError(f"{name} has implausible length: {len(content)}")
        if content.lstrip().startswith("```"):
            raise ValueError(f"{name} contains markdown code fences")
        if "\x00" in content:
            raise ValueError(f"{name} has null bytes")
    for name in ("implementation", "tests", "example"):
        for library in ALLOWED_IMPORTS.findall(result[name]):
            if library.startswith("dart:") or library.startswith("package:flutter/") or library.startswith("package:flutter_test/") or library.startswith(f"package:{item.package}/"):
                continue
            raise ValueError(f"{name} has unsupported import: {library}")
    if "void main(" not in result["tests"] or "void main(" not in result["example"]:
        raise ValueError("Tests and example must each have a main function")
    if "DemoApp" not in result["example"]:
        raise ValueError("Example must define DemoApp")
    if "class " not in result["implementation"]:
        raise ValueError("Core implementation is missing a class")


def package_files(item: Item, content: dict[str, str], license_text: str) -> dict[str, str]:
    package = item.package
    return {
        f"lib/src/{package}.dart": content["implementation"],
        f"lib/{package}.dart": f"export 'src/{package}.dart';\n",
        f"test/{package}_test.dart": content["tests"],
        "example/lib/main.dart": content["example"],
        "README.md": content["readme"],
        "docs/x_publish_kit.md": content["x_publish_kit"],
        "pubspec.yaml": f"""name: {package}
description: A practical Flutter daily component from Flutter Daily Plugins.
version: 0.1.0
publish_to: none

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
""",
        "example/pubspec.yaml": f"""name: {package}_example
description: Demonstration app for {package}.
publish_to: none
version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  {package}:
    path: ../

flutter:
  uses-material-design: true
""",
        "analysis_options.yaml": "include: package:flutter_lints/flutter.yaml\n",
        ".gitignore": ".dart_tool/\n.packages\n.pub/\n.pub-cache/\nbuild/\ncoverage/\n**/ios/Pods/\n**/android/.gradle/\n.idea/\n*.iml\n",
        "CHANGELOG.md": f"# Changelog\n\n## 0.1.0\n\n- Initial {item.title} MVP.\n- Example and automated tests.\n",
        "LICENSE": license_text,
    }


def cmd_generate(args: argparse.Namespace) -> None:
    item = item_for_day(args.roadmap, int(args.day))
    root = args.output_root.resolve()
    dest = root / item.folder
    if dest.exists():
        raise FileExistsError(f"Will not overwrite existing directory: {dest}")
    license_text = args.license.read_text(encoding="utf-8")
    result = ask_model(item, args.model)
    validate_content(item, result)
    files = package_files(item, result, license_text)
    for name, value in files.items():
        path = dest / name
        if not path.resolve().is_relative_to(dest.resolve()):
            raise ValueError(f"Unsafe output path {name}")
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(value.rstrip("\n") + "\n", encoding="utf-8")
    print(f"Generated {len(files)} files at {dest}; NOT TESTED OR PUBLISHED")


def update_index(readme: str, item: Item) -> str:
    if re.search(rf"^\|\s*{item.day:03d}\s*\|", readme, re.M):
        return readme
    row = (f"| {item.day:03d} | [{item.title}]({item.folder}/) | "
           f"{item.description} | Source published; local verification pending |\n")
    rows = list(re.finditer(r"^\|\s*\d{3}\s*\|.*\n", readme, re.M))
    # Insert after last earlier day, otherwise after the table separator.
    earlier = [m for m in rows if int(re.match(r"\|\s*(\d{3})", m.group()).group(1)) < item.day]
    if earlier:
        pos = earlier[-1].end()
    else:
        divider = re.search(r"^\|\s*---\s*\|.*\n", readme, re.M)
        if not divider:
            raise ValueError("Cannot find README project table")
        pos = divider.end()
    return readme[:pos] + row + readme[pos:]


def update_roadmap(roadmap: str, item: Item) -> str:
    lines = roadmap.splitlines(keepends=True)
    count = 0
    for idx, line in enumerate(lines):
        if line.startswith(f"| {item.day:03d} |"):
            if "⬜ 计划中" in line:
                lines[idx] = line.replace("⬜ 计划中", "📦 已提交（待本地验证）", 1)
            count += 1
    if count != 1:
        raise ValueError(f"Found {count} roadmap rows for Day {item.day}")
    return "".join(lines)


def cmd_record(args: argparse.Namespace) -> None:
    item = item_for_day(args.roadmap, int(args.day))
    if not (args.repository_root / item.folder / "pubspec.yaml").is_file():
        raise FileNotFoundError(f"Package not found: {item.folder}")
    old_readme = args.readme.read_text(encoding="utf-8")
    old_roadmap = args.roadmap.read_text(encoding="utf-8")
    new_readme = update_index(old_readme, item)
    new_roadmap = update_roadmap(old_roadmap, item)
    args.readme.write_text(new_readme, encoding="utf-8")
    args.roadmap.write_text(new_roadmap, encoding="utf-8")
    print(f"Indexed Day {item.day:03d} as source submitted, local verification pending")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    plan = sub.add_parser("plan")
    plan.add_argument("--day", default="")
    plan.add_argument("--roadmap", type=Path, default=Path("ROADMAP.md"))
    plan.add_argument("--repository-root", type=Path, default=Path("."))
    plan.add_argument("--github-output", default=os.environ.get("GITHUB_OUTPUT", ""))
    plan.set_defaults(run=cmd_plan)
    generate = sub.add_parser("generate")
    generate.add_argument("--day", required=True)
    generate.add_argument("--model", default=os.environ.get("OPENAI_MODEL", "gpt-5-mini"))
    generate.add_argument("--roadmap", type=Path, default=Path("ROADMAP.md"))
    generate.add_argument("--license", type=Path, default=Path("LICENSE"))
    generate.add_argument("--output-root", type=Path, default=Path("generated"))
    generate.set_defaults(run=cmd_generate)
    record = sub.add_parser("record")
    record.add_argument("--day", required=True)
    record.add_argument("--roadmap", type=Path, default=Path("ROADMAP.md"))
    record.add_argument("--readme", type=Path, default=Path("README.md"))
    record.add_argument("--repository-root", type=Path, default=Path("."))
    record.set_defaults(run=cmd_record)
    args = parser.parse_args()
    try:
        args.run(args)
    except (ValueError, FileNotFoundError, FileExistsError, RuntimeError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()