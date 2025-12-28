import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';

import '../../../core/custom_input.dart';
import '../../../core/primary_button.dart';
import 'login_header.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Command loginCommand;
  final VoidCallback onSubmit;
  final VoidCallback onRegisterTap;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.loginCommand,
    required this.onSubmit,
    required this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: AutofillGroup(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 24, // Requer Flutter 3.27+
          children: [
            const LoginHeader(),

            CustomInput(
              label: 'Email',
              prefixIcon: Icons.email_outlined,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [
                AutofillHints.email,
                AutofillHints.username,
              ],
              textAction: TextInputAction.next,
              validator: (v) =>
                  (v == null || !v.contains('@')) ? 'Email inválido' : null,
            ),

            CustomInput(
              label: 'Senha',
              prefixIcon: Icons.lock_outline,
              controller: passwordController,
              isPassword: true,
              autofillHints: const [AutofillHints.password],
              textAction: TextInputAction.done,
              onSubmitted: onSubmit,
              // Ao dar Enter
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Digite a senha' : null,
            ),

            PrimaryButton(
              label: 'Login',
              command: loginCommand,
              onPressed: onSubmit, // Ao clicar
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Não tem uma conta? '),
                TextButton(
                  onPressed: onRegisterTap,
                  child: const Text(
                    'Cadastre-se',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
