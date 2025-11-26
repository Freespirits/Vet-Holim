import 'package:flutter/material.dart';

/// Breakpoints roughly matching Material 3 window size classes:
/// < 600  : compact  (phone)
/// 600-840: medium   (small tablets / big phones)
/// > 840  : expanded (tablets / desktop)
class AppBreakpoints {
  static const double compact = 600;
  static const double medium = 840;
}

enum DeviceSizeClass { compact, medium, expanded }

DeviceSizeClass sizeClassForWidth(double width) {
  if (width < AppBreakpoints.compact) return DeviceSizeClass.compact;
  if (width < AppBreakpoints.medium) return DeviceSizeClass.medium;
  return DeviceSizeClass.expanded;
}

/// Generic responsive builder you can reuse in any screen.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key, required this.builder});

  final Widget Function(BuildContext context, DeviceSizeClass sizeClass) builder;

  static bool isPhone(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return sizeClassForWidth(width) == DeviceSizeClass.compact;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final sizeClass = sizeClassForWidth(width);
    return sizeClass == DeviceSizeClass.medium ||
        sizeClass == DeviceSizeClass.expanded;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final sizeClass = sizeClassForWidth(width);
        return builder(context, sizeClass);
      },
    );
  }
}
