import 'package:flutter/material.dart';

/// App-wide dark mode; [isDark] and [toggleDark] available to all screens.
class DarkModeScope extends InheritedWidget {
  const DarkModeScope({
    required this.isDark,
    required this.toggleDark,
    required super.child,
    super.key,
  });

  final bool isDark;
  final VoidCallback toggleDark;

  static DarkModeScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DarkModeScope>();
    assert(scope != null, 'DarkModeScope not found. Wrap app with DarkModeScope.');
    return scope!;
  }

  @override
  bool updateShouldNotify(DarkModeScope oldWidget) =>
      isDark != oldWidget.isDark;
}
