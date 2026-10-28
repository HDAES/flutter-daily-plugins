import 'package:flutter/material.dart';

import 'masked_input_formatter.dart';

/// Convenience wrapper around [TextField] and [MaskedInputFormatter].
///
/// The caller owns [controller], if supplied. [onRawChanged] returns only
/// characters accepted by the mask; [onChanged] returns the formatted value.
class MaskedInputField extends StatelessWidget {
  const MaskedInputField({
    super.key,
    required this.mask,
    this.controller,
    this.labelText,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.onChanged,
    this.onRawChanged,
    this.enabled = true,
    this.autofocus = false,
  });

  final String mask;
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onRawChanged;
  final bool enabled;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final formatter = MaskedInputFormatter(mask: mask);
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      enabled: enabled,
      autofocus: autofocus,
      inputFormatters: [formatter],
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        onChanged?.call(value);
        onRawChanged?.call(formatter.unmask(value));
      },
    );
  }
}
