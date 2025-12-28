import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class NameSetupHeader extends StatelessWidget {
  const NameSetupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = Theme.of(context).extension<AppColorsExtension>();

    return Column(
      children: [
        Icon(
          Icons.person_pin_rounded,
          size: 90,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'Quase lá!',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Detectamos que você já tem conta, mas precisamos saber seu nome para o chat.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: customColors?.textSecondary,
          ),
        ),
      ],
    );
  }
}
