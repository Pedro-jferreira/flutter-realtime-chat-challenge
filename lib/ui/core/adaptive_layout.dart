import 'package:flutter/material.dart';

class AdaptiveLayout extends StatelessWidget {
  final Widget child;

  const AdaptiveLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 32,
              ),
              child: IntrinsicHeight(child: child),
            ),
          );
        },
      ),
    );
  }
}
