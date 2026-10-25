# GitHub Actions · Flutter 100-day automatic publishing

This workflow creates a new package from the 100-day roadmap using the **OpenAI API**. It is **not** connected to the ChatGPT scheduled task and does **not** use ChatGPT Plus credits.

## Required owner setup (one-time)

1. Visit **GitHub → HDAES/flutter-daily-plugins → Settings → Secrets and variables → Actions → New repository secret**.
2. Add secret **`OPENAI_API_KEY`** with an active OpenAI API key that has billing enabled. **Never** commit or paste the key into source code or chat.
3. Under **Settings → Actions → General**, ensure GitHub Actions is enabled and the workflow `GITHUB_TOKEN` can write repository contents. Repository or organization policy and branch protection may further limit pushes. The workflow requests `contents: write` **only** in the publish job.
4. Optional: Add Actions repository variable **`OPENAI_MODEL`**, e.g. `gpt-5-mini` (default). This can incur usage-based API costs.
5. Open **Actions → Daily Flutter Plugin → Run workflow**. For a first dry run, enter the next uncommitted Day number (e.g. 003) and leave **publish unchecked**. Check successful generation + Flutter tests; then run again with **publish checked** (or wait for next scheduled day).

## Daily behavior

- `17 1 * * *` (UTC) runs at approximately **09:17 China Standard Time** each day.
- The day is calculated from **2026-10-24 = Day 001**. On 2026-10-26 it creates Day 003, and so on until Day 100. The workflow does **not** silently repeat or overwrite an existing Day directory.
- The generator reads the exact package name/title/description in `ROADMAP.md` and creates `lib/`, `test/`, `example/`, `README.md`, X post draft and blank test-report template.
- A separate **read-only, secret-free validation job** downloads generated code, runs `flutter pub get`, `dart format`, `flutter analyze`, `flutter test`, and analyzes the demo.
- Only if validation passes does `publish` push a new Day directory and update `README.md` and `ROADMAP.md` on `main`.
- A failed generation, API quota/secret issue, failing test, or rejected push **must not be marked as completed**. Download workflow artifacts to troubleshoot. To backfill a missed day, manually supply that Day number.

## Safety / limitations

- Generated code is AI-assisted, **not production-certified**. CI validation is not a security or quality guarantee. Manually review and test on target devices before real deployments or claiming that device testing passed.
- The OpenAI API key is only available to the generation job. Generated Dart code is executed in a different GitHub Actions job **without that secret or repository write permission**.
- The publish step does not execute generated Dart code; it only stages the fixed Day directory and updates the indexes.
- Model output is limited to a fixed set of file names. Runtime dependencies are limited to the Flutter SDK in this MVP; projects needing third-party native plugins will require future extension and device-specific verification.
- If branch protection forbids direct `main` pushes, modify the workflow to open a PR instead or adjust repository branch rules. Do not turn off security protections casually.
- GitHub scheduled runs can be delayed or skipped under platform load. Check **Actions** for run logs; a workflow notification is not guaranteed.
- ChatGPT's separate daily reminder/task may also produce a plugin independently. The GitHub Action is its own generator, so outputs might differ. Use one source as canonical before publishing to X.

## Local helper commands

```bash
python3 scripts/daily_plugin.py plan --day 003
python3 scripts/daily_plugin.py plan  # day from China time
OPENAI_API_KEY=... python3 scripts/daily_plugin.py generate --day 003
python3 -m unittest discover -s scripts -p 'test_*.py'
```

Do not put a real API key into terminal history on shared machines. Use environment variable injection/secrets for credentials.