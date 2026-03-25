import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.size = 24, this.center = true});

  final double size;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final content = SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(strokeWidth: 2.6),
    );

    if (!center) {
      return content;
    }

    return Center(child: content);
  }
}
