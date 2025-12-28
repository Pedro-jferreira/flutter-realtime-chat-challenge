import 'package:desafio_flugo_flutter/ui/feature/register/widgets/name_setup_form.dart';
import 'package:desafio_flugo_flutter/ui/feature/register/widgets/name_setup_header.dart';
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

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await context.read<LoginViewModel>().completeProfileCommand.execute(
        _nameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completar Perfil'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            spacing: 40,
            children: [
              NameSetupHeader(),
              NameSetupForm(
                formKey: _formKey,
                nameController: _nameController,
                onSubmit: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
