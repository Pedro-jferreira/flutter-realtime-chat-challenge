import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login/view_model/login_view_model.dart';

class NameSetupScreen extends StatefulWidget {
  const NameSetupScreen({super.key});

  @override
  State<NameSetupScreen> createState() => _NameSetupScreenState();
}

class _NameSetupScreenState extends State<NameSetupScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Podemos usar o LoginViewModel pois ele tem o 'completeProfileCommand'
    final viewModel = context.read<LoginViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Completar Perfil'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_pin_rounded,
                  size: 80,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Quase lá!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Detectamos que você já tem conta, mas precisamos saber seu nome para o chat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Seu Nome',
                    hintText: 'Como quer ser chamado?',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length < 3) {
                      return 'Por favor, digite um nome válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                ListenableBuilder(
                  listenable: viewModel.completeProfileCommand,
                  builder: (context, _) {
                    if (viewModel.completeProfileCommand.isRunning) {
                      return const CircularProgressIndicator();
                    }

                    return ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await viewModel.completeProfileCommand.execute(
                            _nameController.text.trim(),
                          );
                        }
                      },
                      child: const Text('Salvar e Entrar'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
