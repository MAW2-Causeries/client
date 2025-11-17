import 'package:flutter/material.dart';

class BaseInput extends StatelessWidget {
  const BaseInput({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.validator,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String?)? validator;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      controller: controller,
      initialValue: initialValue,
      validator: validator,
      obscureText: obscureText,
    );
  }
}
