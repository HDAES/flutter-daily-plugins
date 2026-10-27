/// Individual checks used by the demonstrative password policy.
enum PasswordRule { minimumLength, lowercase, uppercase, number, symbol }

/// Qualitative rule-coverage label, not a measure of password entropy.
enum PasswordStrengthLevel { none, weak, fair, good, strong }

/// Immutable evaluation result; the raw password is never retained.
class PasswordStrengthResult {
  const PasswordStrengthResult({
    required this.hasInput,
    required this.checks,
    required this.level,
    required this.passedRules,
  });

  final bool hasInput;
  final Map<PasswordRule, bool> checks;
  final PasswordStrengthLevel level;
  final int passedRules;

  int get totalRules => PasswordRule.values.length;
  double get progress => passedRules / totalRules;
  bool get meetsAllRules => hasInput && passedRules == totalRules;
  bool passes(PasswordRule rule) => checks[rule] ?? false;
}

/// Simple checklist for UI hints. Never use as a security-grade estimator.
/// ASCII character classes and code-unit length are intentional MVP limits.
class PasswordStrengthEvaluator {
  const PasswordStrengthEvaluator();

  PasswordStrengthResult evaluate(String password, {int minLength = 8}) {
    if (minLength < 1) {
      throw ArgumentError.value(minLength, 'minLength', 'Must be positive');
    }

    final checks = Map<PasswordRule, bool>.unmodifiable({
      PasswordRule.minimumLength: password.length >= minLength,
      PasswordRule.lowercase: RegExp(r'[a-z]').hasMatch(password),
      PasswordRule.uppercase: RegExp(r'[A-Z]').hasMatch(password),
      PasswordRule.number: RegExp(r'[0-9]').hasMatch(password),
      PasswordRule.symbol: RegExp(r'[^A-Za-z0-9\s]').hasMatch(password),
    });
    final passed = checks.values.where((value) => value).length;

    final PasswordStrengthLevel level;
    if (password.isEmpty) {
      level = PasswordStrengthLevel.none;
    } else if (!checks[PasswordRule.minimumLength]!) {
      level = PasswordStrengthLevel.weak;
    } else if (passed <= 2) {
      level = PasswordStrengthLevel.weak;
    } else if (passed == 3) {
      level = PasswordStrengthLevel.fair;
    } else if (passed == 4) {
      level = PasswordStrengthLevel.good;
    } else {
      level = PasswordStrengthLevel.strong;
    }

    return PasswordStrengthResult(
      hasInput: password.isNotEmpty,
      checks: checks,
      level: level,
      passedRules: passed,
    );
  }
}
