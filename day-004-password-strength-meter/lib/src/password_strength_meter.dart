import 'package:flutter/material.dart';

import 'password_strength_evaluator.dart';

/// Rule-coverage UI. The parent owns and updates the password.
class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({
    super.key,
    required this.password,
    this.minLength = 8,
    this.showRules = true,
    this.showLabel = true,
    this.showProgress = true,
  }) : assert(minLength > 0);

  final String password;
  final int minLength;
  final bool showRules;
  final bool showLabel;
  final bool showProgress;

  static const _evaluator = PasswordStrengthEvaluator();

  @override
  Widget build(BuildContext context) {
    final result = _evaluator.evaluate(password, minLength: minLength);
    final theme = Theme.of(context);
    final color = _colorFor(result.level, theme);
    final passed = result.passedRules;
    final total = result.totalRules;
    final levelText = _levelLabel(result.level);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Row(
            children: [
              Text('密码强度', style: theme.textTheme.bodyMedium),
              const Spacer(),
              Text(
                levelText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        if (showProgress)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Semantics(
              label: '密码规则满足 $passed / $total，强度$levelText',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: result.progress,
                  minHeight: 8,
                  color: color,
                  backgroundColor: theme.dividerColor,
                ),
              ),
            ),
          ),
        if (showRules)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final rule in PasswordRule.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Icon(
                          result.passes(rule)
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          size: 17,
                          color: result.passes(rule)
                              ? theme.colorScheme.primary
                              : theme.disabledColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _ruleLabel(rule, minLength),
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  static String _ruleLabel(PasswordRule rule, int minLength) {
    switch (rule) {
      case PasswordRule.minimumLength:
        return '至少 $minLength 个字符';
      case PasswordRule.lowercase:
        return '包含小写英文字母';
      case PasswordRule.uppercase:
        return '包含大写英文字母';
      case PasswordRule.number:
        return '包含数字';
      case PasswordRule.symbol:
        return '包含符号';
    }
  }

  static String _levelLabel(PasswordStrengthLevel level) {
    switch (level) {
      case PasswordStrengthLevel.none:
        return '未输入';
      case PasswordStrengthLevel.weak:
        return '弱';
      case PasswordStrengthLevel.fair:
        return '一般';
      case PasswordStrengthLevel.good:
        return '良好';
      case PasswordStrengthLevel.strong:
        return '强';
    }
  }

  static Color _colorFor(PasswordStrengthLevel level, ThemeData theme) {
    switch (level) {
      case PasswordStrengthLevel.none:
        return theme.disabledColor;
      case PasswordStrengthLevel.weak:
        return theme.colorScheme.error;
      case PasswordStrengthLevel.fair:
        return Colors.orange;
      case PasswordStrengthLevel.good:
        return Colors.blue;
      case PasswordStrengthLevel.strong:
        return Colors.green;
    }
  }
}
