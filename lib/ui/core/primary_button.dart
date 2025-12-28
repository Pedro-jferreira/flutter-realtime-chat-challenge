import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Command? command;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.command,
  });

  @override
  Widget build(BuildContext context) {
    if (command == null) {
      return _buildButton();
    }

    return ListenableBuilder(
      listenable: command!,
      builder: (context, _) {
        if (command!.value.isRunning) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildButton();
      },
    );
  }

  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
