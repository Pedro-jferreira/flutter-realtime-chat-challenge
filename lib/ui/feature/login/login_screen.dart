import 'package:desafio_flugo_flutter/ui/core/adaptive_layout.dart';
import 'package:desafio_flugo_flutter/ui/core/logo_flugo.dart';
import 'package:desafio_flugo_flutter/ui/feature/login/view_model/login_view_model.dart';
import 'package:desafio_flugo_flutter/ui/feature/login/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:result_command/result_command.dart';

import '../../../models/gen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final LoginViewModel _viewModel;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _viewModel = context.read<LoginViewModel>();
    _viewModel.loginCommand.addListener(_handleLogin);
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.loginCommand.removeListener(_handleLogin);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Sempre verificar se o widget ainda existe
    if (!mounted) return;

    final cmd = _viewModel.loginCommand;

    switch (cmd.value) {
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
            content: Text('Bem-vindo de volta!'),
            backgroundColor: Colors.green,
          ),
        );
        break;

      default:
        return;
    }
  }

  Future<void> _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final input = LoginInput(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      await _viewModel.loginCommand.execute(input);
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
                child: LoginForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  loginCommand: _viewModel.loginCommand,
                  onSubmit: _submitLogin,
                  onRegisterTap: () => context.push('/register'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
