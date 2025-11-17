import 'package:causeries_client/src/themes/app_theme.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final Function onPressed;

  const Button({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(label, style: AppTheme.textTheme.bodyMedium),
    );
  }
}
