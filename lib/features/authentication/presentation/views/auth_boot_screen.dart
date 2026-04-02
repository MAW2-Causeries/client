import 'package:causeries_client/app/routes.dart';
import 'package:causeries_client/core/network/api_client.dart';
import 'package:causeries_client/core/storage/token_storage.dart';
import 'package:causeries_client/core/widgets/app_loading.dart';
import 'package:causeries_client/features/authentication/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthBootScreen extends StatefulWidget {
  const AuthBootScreen({super.key});

  @override
  State<AuthBootScreen> createState() => _AuthBootScreenState();
}

class _AuthBootScreenState extends State<AuthBootScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final tokenStorage = context.read<TokenStorage>();

    final hasToken = await tokenStorage.hasToken();
    if (!mounted) return;

    if (!hasToken) {
      Navigator.of(context).pushReplacementNamed(Routes.login);
      return;
    }

    try {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(Routes.guildHome);
    } catch (e) {
      if (e is ApiException && e.statusCode != 401) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(Routes.guildHome);
        return;
      }

      await tokenStorage.clear();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: AppLoading()));
  }
}
