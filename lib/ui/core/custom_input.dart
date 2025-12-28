import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final String label;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textAction;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final VoidCallback? onSubmitted;
  final TextCapitalization textCapitalization;

  const CustomInput({
    super.key,
    required this.label,
    required this.prefixIcon,
    required this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.textAction,
    this.autofillHints,
    this.validator,
    this.onSubmitted,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isObscured = widget.isPassword && _obscureText;
    return TextFormField(
      controller: widget.controller,
      obscureText: isObscured,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textAction,
      autofillHints: widget.autofillHints,
      onFieldSubmitted: widget.onSubmitted != null
          ? (_) => widget.onSubmitted!()
          : null,
      textCapitalization: widget.textCapitalization,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: Icon(widget.prefixIcon),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  isObscured
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}
