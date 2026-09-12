import 'package:flutter/material.dart';

/// Dismisses the keyboard when the user taps outside a focused text field.
class KeyboardDismisser extends StatelessWidget {
  const KeyboardDismisser({super.key, required this.child});

  final Widget child;

  static void dismiss() => FocusManager.instance.primaryFocus?.unfocus();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: dismiss,
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}
