import 'dart:async';

import 'package:flutter/material.dart';

/// A search input that calls [onSearch] after the user stops editing.
///
/// Typing is debounced; pressing the keyboard search action or tapping Clear
/// emits immediately. Consecutive identical searches are suppressed.
///
/// This widget does not make network requests or cancel existing requests.
class DebouncedSearchField extends StatefulWidget {
  const DebouncedSearchField({
    super.key,
    required this.onSearch,
    this.controller,
    this.focusNode,
    this.debounceDuration = const Duration(milliseconds: 350),
    this.hintText = 'Search...',
    this.clearTooltip = 'Clear search',
    this.enabled = true,
    this.autofocus = false,
    this.onChanged,
    this.onCleared,
  });

  /// Called for a new query after the debounce, on submit, or on clear.
  final ValueChanged<String> onSearch;

  /// Optional external controller. The widget never disposes this controller.
  final TextEditingController? controller;

  /// Optional focus node; owned and disposed by the caller when provided.
  final FocusNode? focusNode;

  /// Duration between the last edit and [onSearch]. Zero means immediate.
  final Duration debounceDuration;

  final String hintText;
  final String clearTooltip;
  final bool enabled;
  final bool autofocus;

  /// Called for each controller text change, including programmatic changes.
  final ValueChanged<String>? onChanged;

  /// Called when the clear icon is tapped (after an immediate empty search).
  final VoidCallback? onCleared;

  @override
  State<DebouncedSearchField> createState() => _DebouncedSearchFieldState();
}

class _DebouncedSearchFieldState extends State<DebouncedSearchField> {
  late TextEditingController _controller;
  late bool _ownsController;
  Timer? _debounceTimer;
  String? _lastEmittedQuery;

  @override
  void initState() {
    super.initState();
    assert(!widget.debounceDuration.isNegative);
    _bindController(widget.controller);
  }

  void _bindController(TextEditingController? external) {
    _ownsController = external == null;
    _controller = external ?? TextEditingController();
    _controller.addListener(_handleTextChange);
  }

  void _cancelPending() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }

  void _emit(String query) {
    if (_lastEmittedQuery == query) return;
    _lastEmittedQuery = query;
    widget.onSearch(query);
  }

  void _handleTextChange() {
    if (!mounted) return;
    setState(() {});
    final query = _controller.text;
    widget.onChanged?.call(query);
    _cancelPending();
    if (!widget.enabled) return;

    if (widget.debounceDuration == Duration.zero) {
      _emit(query);
    } else {
      _debounceTimer = Timer(widget.debounceDuration, () {
        _debounceTimer = null;
        if (mounted && widget.enabled) _emit(query);
      });
    }
  }

  void _clear() {
    if (!widget.enabled || _controller.text.isEmpty) return;
    // The listener may schedule a debounce; cancel it and emit immediately.
    _controller.clear();
    _cancelPending();
    _emit('');
    widget.onCleared?.call();
  }

  void _submit(String query) {
    _cancelPending();
    if (widget.enabled) _emit(query);
  }

  @override
  void didUpdateWidget(covariant DebouncedSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(!widget.debounceDuration.isNegative);

    if (oldWidget.controller != widget.controller) {
      _cancelPending();
      _controller.removeListener(_handleTextChange);
      if (_ownsController) _controller.dispose();
      _bindController(widget.controller);
      _lastEmittedQuery = null;
    }

    if (!widget.enabled ||
        oldWidget.debounceDuration != widget.debounceDuration) {
      // A changed debounce policy invalidates the old timer.
      _cancelPending();
    }
  }

  @override
  void dispose() {
    _cancelPending();
    _controller.removeListener(_handleTextChange);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      textInputAction: TextInputAction.search,
      onSubmitted: _submit,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: widget.clearTooltip,
                icon: const Icon(Icons.clear),
                onPressed: widget.enabled ? _clear : null,
              ),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
