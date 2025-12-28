import 'package:flutter/material.dart';

class LogoFlugo extends StatelessWidget {
  const LogoFlugo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/flugo_logo.png', // Certifique-se que o asset existe
      height: 80,
      fit: BoxFit.contain,
    );
  }
}
