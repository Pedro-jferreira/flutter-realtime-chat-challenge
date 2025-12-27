import 'package:desafio_flugo_flutter/ui/feature/register/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:result_command/src/command.dart';

import '../../../models/gen.dart';

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
  bool _isPasswordVisible = false;

  late final RegisterViewModel _registerViewModel;

  @override
  void initState() {
    _registerViewModel = context.read<RegisterViewModel>();

    _registerViewModel.registerCommand.addListener(handlerRegister);
    super.initState();
  }

  handlerRegister() {
    final cmd = _registerViewModel.registerCommand;
    final value = cmd.value;

    // IMPORTANTE: Sempre verifique se o widget ainda está na tela
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
          onPressed: () => context.go('/login'), // Volta explicitamente
        ),
      ),
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
                            spacing: 8,
                            children: [
                              Text(
                                'Crie sua conta',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                              ),
                              Text(
                                'Comece a colaborar com sua equipe',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[600]),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),

                          // INPUT NOME
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nome Completo',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            autofillHints: const [AutofillHints.name],
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
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

                          // INPUT EMAIL
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            autofillHints: const [
                              AutofillHints.username,
                              AutofillHints.email,
                            ],
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email obrigatório';
                              }
                              if (!value.contains('@')) return 'Email inválido';
                              return null;
                            },
                          ),

                          // INPUT SENHA
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            autofillHints: const [AutofillHints.newPassword],
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () => setState(
                                  () =>
                                      _isPasswordVisible = !_isPasswordVisible,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Mínimo de 6 caracteres';
                              }
                              return null;
                            },
                          ),

                          // INPUT CONFIRMAR SENHA
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !_isPasswordVisible,
                            autofillHints: const [AutofillHints.newPassword],
                            textInputAction: TextInputAction.done,

                            // 6. Submete ao dar Enter/Done
                            onFieldSubmitted: (_) => _submitRegister(),
                            decoration: const InputDecoration(
                              labelText: 'Confirmar Senha',
                              prefixIcon: Icon(Icons.lock_reset),
                            ),
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'As senhas não coincidem';
                              }
                              if (value == null || value.length < 6) {
                                return 'Mínimo de 6 caracteres';
                              }
                              return null;
                            },
                          ),

                          ListenableBuilder(
                            listenable: _registerViewModel.registerCommand,
                            builder: (context, _) {
                              if (_registerViewModel
                                  .registerCommand
                                  .value
                                  .isRunning) {
                                return const CircularProgressIndicator();
                              }

                              return ElevatedButton(
                                onPressed: _submitRegister,
                                child: const Text('Criar Conta'),
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Já tem uma conta? '),
                              TextButton(
                                onPressed: () => context.go('/login'),
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
