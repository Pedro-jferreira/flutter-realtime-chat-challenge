import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<AppColorsExtension>();
    return Column(
      children: [
        Text(
          'Entrar',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Digite suas credenciais para continuar',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: customColors?.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
