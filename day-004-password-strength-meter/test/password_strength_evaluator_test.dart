import 'package:flutter_test/flutter_test.dart';
import 'package:password_strength_meter/password_strength_meter.dart';

void main() {
  const evaluator = PasswordStrengthEvaluator();

  test('empty input has no strength', () {
    final result = evaluator.evaluate('');
    expect(result.level, PasswordStrengthLevel.none);
    expect(result.passedRules, 0);
    expect(result.progress, 0);
    expect(result.meetsAllRules, isFalse);
  });

  test('length boundary and lowercase check', () {
    final short = evaluator.evaluate('abcdefg');
    final long = evaluator.evaluate('abcdefgh');
    expect(short.passes(PasswordRule.minimumLength), isFalse);
    expect(long.passes(PasswordRule.minimumLength), isTrue);
    expect(long.passedRules, 2);
  });

  test('labels follow rule coverage', () {
    expect(evaluator.evaluate('Abcdefgh').level, PasswordStrengthLevel.fair);
    expect(evaluator.evaluate('Abcdefg1').level, PasswordStrengthLevel.good);
    expect(evaluator.evaluate('Abcdefg1!').level, PasswordStrengthLevel.strong);
  });

  test('short mixed passwords remain weak', () {
    final result = evaluator.evaluate('Aa1!');
    expect(result.passedRules, 4);
    expect(result.level, PasswordStrengthLevel.weak);
    expect(result.meetsAllRules, isFalse);
  });

  test('custom minimum length is respected', () {
    final result = evaluator.evaluate('Abcdefg1!', minLength: 12);
    expect(result.passes(PasswordRule.minimumLength), isFalse);
    expect(result.level, PasswordStrengthLevel.weak);
  });

  test('whitespace does not count as a symbol', () {
    expect(
      evaluator.evaluate('Abcdefg1 ').passes(PasswordRule.symbol),
      isFalse,
    );
  });

  test('complete checklist has full progress and immutable checks', () {
    final result = evaluator.evaluate('Abcdefg1!');
    expect(result.progress, 1);
    expect(result.meetsAllRules, isTrue);
    expect(result.checks.length, 5);
    expect(
      () => result.checks[PasswordRule.number] = false,
      throwsUnsupportedError,
    );
  });

  test('invalid minimum length throws', () {
    expect(() => evaluator.evaluate('abc', minLength: 0), throwsArgumentError);
  });
}
