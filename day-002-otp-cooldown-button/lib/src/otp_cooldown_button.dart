import 'dart:async';

import 'package:flutter/material.dart';

/// A button for requesting a one-time code, with a resend cooldown.
///
/// The countdown starts only after [onSend] completes successfully. Throw
/// from [onSend] when the server rejects the request so the button can retry.
/// The cooldown is local to this widget and is not a security boundary.
class OtpCooldownButton extends StatefulWidget {
  const OtpCooldownButton({
    super.key,
    required this.onSend,
    this.label = '发送验证码',
    this.sendingLabel = '发送中…',
    this.cooldownSeconds = 60,
    this.enabled = true,
    this.onError,
    this.countdownLabelBuilder,
    this.style,
  }) : assert(cooldownSeconds > 0, 'cooldownSeconds must be positive');

  /// Called once for each accepted tap. A thrown error skips the cooldown.
  final Future<void> Function() onSend;
  final String label;
  final String sendingLabel;
  final int cooldownSeconds;
  final bool enabled;
  final void Function(Object error, StackTrace stackTrace)? onError;
  final String Function(int remainingSeconds)? countdownLabelBuilder;
  final ButtonStyle? style;

  @override
  State<OtpCooldownButton> createState() => _OtpCooldownButtonState();
}

class _OtpCooldownButtonState extends State<OtpCooldownButton>
    with WidgetsBindingObserver {
  Timer? _timer;
  DateTime? _deadline;
  bool _sending = false;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _handleTap() async {
    if (!widget.enabled || _sending || _remainingSeconds > 0) return;

    // Acquire the lock synchronously, before invoking the async callback.
    setState(() => _sending = true);
    try {
      await widget.onSend();
      if (!mounted) return;
      _startCooldown();
    } catch (error, stackTrace) {
      if (!mounted) return;
      final handler = widget.onError;
      if (handler != null) {
        handler(error, stackTrace);
      } else {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'otp_cooldown_button',
            context: ErrorDescription('while requesting an OTP code'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _startCooldown() {
    _timer?.cancel();
    _deadline = DateTime.now().add(Duration(seconds: widget.cooldownSeconds));
    setState(() => _remainingSeconds = widget.cooldownSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remainingSeconds <= 1) {
        _stopCooldown();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _stopCooldown() {
    _timer?.cancel();
    _timer = null;
    _deadline = null;
    if (mounted && _remainingSeconds != 0) {
      setState(() => _remainingSeconds = 0);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || _deadline == null) return;

    // A periodic timer may be paused/throttled in the background. Reconcile
    // against wall-clock time when the application becomes active again.
    final milliseconds = _deadline!.difference(DateTime.now()).inMilliseconds;
    final remaining = milliseconds <= 0 ? 0 : (milliseconds + 999) ~/ 1000;
    if (remaining == 0) {
      _stopCooldown();
    } else if (remaining != _remainingSeconds) {
      setState(() => _remainingSeconds = remaining);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCoolingDown = _remainingSeconds > 0;
    final canSend = widget.enabled && !_sending && !isCoolingDown;
    final countdownText = isCoolingDown
        ? (widget.countdownLabelBuilder?.call(_remainingSeconds) ??
            '$_remainingSeconds 秒后重发')
        : widget.label;
    final text = _sending
        ? widget.sendingLabel
        : isCoolingDown
            ? countdownText
            : widget.label;

    return ElevatedButton(
      onPressed: canSend ? _handleTap : null,
      style: widget.style,
      child: _sending
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
                Text(text),
              ],
            )
          : Text(text),
    );
  }
}