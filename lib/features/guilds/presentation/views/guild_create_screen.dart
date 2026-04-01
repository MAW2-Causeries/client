import 'package:causeries_client/features/guilds/domain/entities/guild.dart';
import 'package:causeries_client/features/guilds/domain/repositories/guilds_repository.dart';
import 'package:causeries_client/core/network/api_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GuildCreateScreen extends StatefulWidget {
  const GuildCreateScreen({super.key});

  @override
  State<GuildCreateScreen> createState() => _GuildCreateScreenState();
}

class GuildCreateDialog extends StatefulWidget {
  const GuildCreateDialog({super.key});

  @override
  State<GuildCreateDialog> createState() => _GuildCreateDialogState();
}

class _GuildCreateDialogState extends State<GuildCreateDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Guild name is required.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final Guild guild = await context.read<GuildsRepository>().createGuild(
        name: name,
        description: description,
      );
      if (!mounted) return;
      Navigator.of(context).pop(guild);
    } catch (e) {
      if (!mounted) return;
      if (e is ApiException) {
        setState(() => _error = e.message);
      } else {
        setState(() => _error = 'Failed to create guild.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: 24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'New guild',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      tooltip: 'Close',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Guild name',
                    hintText: 'e.g. Causeries',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  textInputAction: TextInputAction.done,
                  minLines: 2,
                  maxLines: 4,
                  onFieldSubmitted: (_) => _create(),
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'A short description for your guild',
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _isLoading ? null : _create,
                  child: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GuildCreateScreenState extends State<GuildCreateScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Guild name is required.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final Guild guild = await context.read<GuildsRepository>().createGuild(
        name: name,
        description: description,
      );
      if (!mounted) return;
      Navigator.of(context).pop(guild);
    } catch (e) {
      if (!mounted) return;
      if (e is ApiException) {
        setState(() => _error = e.message);
      } else {
        setState(() => _error = 'Failed to create guild.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create guild')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'New guild',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Guild name',
                      hintText: 'e.g. Causeries',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    textInputAction: TextInputAction.done,
                    minLines: 2,
                    maxLines: 4,
                    onFieldSubmitted: (_) => _create(),
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'A short description for your guild',
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _isLoading ? null : _create,
                    child: _isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Create'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
