import 'package:flutter/material.dart';

/// A button that disables itself while an asynchronous action is in progress.
///
/// It prevents duplicate taps within this widget instance. It does not replace
/// server-side idempotency keys or database uniqueness constraints.
class GuardedAsyncButton extends StatefulWidget {
  const GuardedAsyncButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.loadingLabel = '处理中…',
    this.enabled = true,
    this.onError,
    this.style,
  });

  /// The asynchronous action invoked on the first accepted tap.
  final Future<void> Function() onPressed;

  /// Visible button text when idle.
  final String label;

  /// Visible button text while the action is pending.
  final String loadingLabel;

  /// Whether the button may accept taps while idle.
  final bool enabled;

  /// Called when [onPressed] throws. If omitted, Flutter reports the error.
  final void Function(Object error, StackTrace stackTrace)? onError;

  /// Optional Material [ButtonStyle].
  final ButtonStyle? style;

  @override
  State<GuardedAsyncButton> createState() => _GuardedAsyncButtonState();
}

class _GuardedAsyncButtonState extends State<GuardedAsyncButton> {
  bool _isLoading = false;

  Future<void> _handlePressed() async {
    if (_isLoading || !widget.enabled) return;

    // Lock synchronously before calling the user callback.
    setState(() => _isLoading = true);
    try {
      await widget.onPressed();
    } catch (error, stackTrace) {
      final onError = widget.onError;
      if (onError != null) {
        onError(error, stackTrace);
      } else {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'guarded_async_button',
            context: ErrorDescription('while handling an async button press'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.enabled && !_isLoading ? _handlePressed : null,
      style: widget.style,
      child: _isLoading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
                Text(widget.loadingLabel),
              ],
            )
          : Text(widget.label),
    );
  }
}
