import 'package:desafio_flugo_flutter/ui/core/adaptive_layout.dart';
import 'package:desafio_flugo_flutter/ui/feature/register/view_models/view_models.dart';
import 'package:desafio_flugo_flutter/ui/feature/register/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:result_command/result_command.dart';

import '../../../models/gen.dart';
import '../../core/logo_flugo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late final RegisterViewModel _registerViewModel;

  @override
  void initState() {
    _registerViewModel = context.read<RegisterViewModel>();

    _registerViewModel.registerCommand.addListener(handlerRegister);
    super.initState();
  }

  void handlerRegister() {
    final cmd = _registerViewModel.registerCommand;
    final value = cmd.value;

    if (!mounted) return;

    switch (value) {
      case FailureCommand(error: final error):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;

      case SuccessCommand():
        TextInput.finishAutofillContext();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conta criada! Entrando...'),
            backgroundColor: Colors.green, // Verde para sucesso
          ),
        );
        break;

      default:
        // Ignora RunningCommand ou None
        return;
    }
  }

  @override
  void dispose() {
    _registerViewModel.registerCommand.removeListener(handlerRegister);

    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitRegister() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final input = RegisterInput(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      await _registerViewModel.registerCommand.execute(input);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdaptiveLayout(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LogoFlugo(),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: RegisterForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  registerCommand: _registerViewModel.registerCommand,
                  onSubmitted: _submitRegister,
                  onLoginTap: () => context.go('/login'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
