import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<AppColorsExtension>();
    return Column(
      children: [
        Text(
          'Crie sua conta',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Comece a colaborar com sua equipe',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: customColors?.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
