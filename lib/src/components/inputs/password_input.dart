import 'package:causeries_client/l10n/app_localizations.dart';
import 'package:causeries_client/src/components/inputs/base_input.dart';
import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
    required this.label,
    this.controller,
    this.validate = true,
  });

  final String label;
  final TextEditingController? controller;
  final bool validate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BaseInput(
      label: label,
      controller: controller,
      validator: validate
          ? (value) {
              if (value == null || value.isEmpty || value.length < 12) {
                return l10n.invalidPassword(12);
              }

              return null;
            }
          : null,
      obscureText: true,
    );
  }
}
