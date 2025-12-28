import 'package:desafio_flugo_flutter/ui/core/primary_button.dart';
import 'package:desafio_flugo_flutter/ui/feature/register/widgets/register_header.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';

import '../../../core/custom_input.dart';

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final Command registerCommand;
  final VoidCallback onSubmitted;
  final VoidCallback onLoginTap;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.registerCommand,
    required this.onSubmitted,
    required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: AutofillGroup(
        child: Column(
          spacing: 24,
          mainAxisSize: MainAxisSize.min,
          children: [
            RegisterHeader(),
            CustomInput(
              label: 'Nome Completo',
              prefixIcon: Icons.person_outline,
              controller: nameController,
              autofillHints: const [AutofillHints.name],
              textAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nome obrigatório';
                }
                if (value.trim().split(' ').length < 2) {
                  return 'Digite nome e sobrenome';
                }
                return null;
              },
            ),
            CustomInput(
              label: 'Email',
              prefixIcon: Icons.email_outlined,
              controller: emailController,
              autofillHints: const [
                AutofillHints.email,
                AutofillHints.newUsername,
              ],
              textAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email obrigatório';
                }
                if (!value.contains('@')) {
                  return 'Email inválido';
                }
                return null;
              },
            ),
            CustomInput(
              isPassword: true,
              label: 'Senha',
              prefixIcon: Icons.lock_outline,
              controller: passwordController,
              autofillHints: const [AutofillHints.newPassword],
              textAction: TextInputAction.next,
              keyboardType: TextInputType.visiblePassword,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Mínimo de 6 caracteres';
                }
                return null;
              },
            ),
            CustomInput(
              isPassword: true,
              label: 'Confirmar Senha',
              prefixIcon: Icons.lock_reset,
              controller: confirmPasswordController,
              autofillHints: const [AutofillHints.newPassword],
              textAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              onSubmitted: onSubmitted,
              validator: (value) {
                if (value != passwordController.text) {
                  return 'As senhas não coincidem';
                }
                if (value == null || value.length < 6) {
                  return 'Mínimo de 6 caracteres';
                }
                return null;
              },
            ),
            PrimaryButton(
              label: 'Criar Conta',
              onPressed: onSubmitted,
              command: registerCommand,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Já tem uma conta? '),
                TextButton(
                  onPressed: onLoginTap,
                  child: const Text(
                    'Faça Login',
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
