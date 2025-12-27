import 'package:desafio_flugo_flutter/ui/feature/login/view_model/login_view_model.dart';
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

  bool _isPasswordVisible = false;

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
    // Acessa o ViewModel

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/flugo_logo.png',
                height: 80,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 50),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: AutofillGroup(
                      child: Column(
                        spacing: 24,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Entrar',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Digite suas credenciais para continuar',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[600]),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),

                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            autofillHints: const [AutofillHints.email],
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Digite seu email';
                              }
                              if (!value.contains('@')) return 'Email inválido';
                              return null;
                            },
                          ),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            autofillHints: const [AutofillHints.password],
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submitLogin(),
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Digite sua senha';
                              }
                              return null;
                            },
                          ),

                          ListenableBuilder(
                            listenable: _viewModel.loginCommand,
                            builder: (context, _) {
                              // Se estiver carregando, mostra o spinner
                              if (_viewModel.loginCommand.value.isRunning) {
                                return const CircularProgressIndicator();
                              }

                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _submitLogin,
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Não tem uma conta? '),
                              TextButton(
                                onPressed: () {
                                  context.push('/register');
                                },
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
