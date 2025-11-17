import 'package:causeries_client/l10n/app_localizations.dart';
import 'package:causeries_client/src/components/inputs/base_input.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BaseInput(
      label: label,
      controller: controller,
      initialValue: initialValue,
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            EmailValidator.validate(value) == false) {
          return l10n.invalidEmail;
        }
        return null;
      },
    );
  }
}
