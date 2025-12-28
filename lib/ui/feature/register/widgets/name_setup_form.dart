import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/custom_input.dart';
import '../../../core/primary_button.dart';
import '../../login/view_model/login_view_model.dart';

class NameSetupForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final void Function() onSubmit;

  const NameSetupForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 25,
        children: [
          CustomInput(
            label: 'Seu Nome Completo',
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
          Consumer<LoginViewModel>(
            builder: (context, viewModel, _) {
              return PrimaryButton(
                label: 'Salvar e Entrar',
                onPressed: onSubmit,
                command: viewModel.completeProfileCommand,
              );
            },
          ),
        ],
      ),
    );
  }
}
