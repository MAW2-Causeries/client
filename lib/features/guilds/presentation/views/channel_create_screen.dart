import 'package:causeries_client/features/guilds/domain/entities/channel.dart';
import 'package:causeries_client/features/guilds/domain/repositories/channels_repository.dart';
import 'package:causeries_client/core/network/api_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChannelCreateScreen extends StatefulWidget {
  const ChannelCreateScreen({super.key});

  @override
  State<ChannelCreateScreen> createState() => _ChannelCreateScreenState();
}

class ChannelCreateDialog extends StatefulWidget {
  final String guildId;
  final String? guildName;

  const ChannelCreateDialog({super.key, required this.guildId, this.guildName});

  @override
  State<ChannelCreateDialog> createState() => _ChannelCreateDialogState();
}

class _ChannelCreateDialogState extends State<ChannelCreateDialog> {
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
    final raw = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    if (raw.isEmpty) {
      setState(() => _error = 'Channel name is required.');
      return;
    }
    final normalized = raw
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'[^a-z0-9\-]'), '');
    final name = normalized.isEmpty ? raw : normalized;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final Channel channel = await context
          .read<ChannelsRepository>()
          .createChannel(
            name: name,
            description: description,
            guildId: widget.guildId,
          );
      if (!mounted) return;
      Navigator.of(context).pop(channel);
    } catch (e) {
      if (!mounted) return;
      if (e is ApiException) {
        setState(() => _error = e.message);
      } else {
        setState(() => _error = 'Failed to create channel.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.guildName == null
        ? 'New channel'
        : 'New channel in ${widget.guildName}';

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
                        title,
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
                    labelText: 'Channel name',
                    hintText: 'e.g. general',
                    prefixText: '# ',
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
                    hintText: 'What is this channel for?',
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
                      : const Text('Add channel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChannelCreateScreenState extends State<ChannelCreateScreen> {
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

  Future<void> _create(String guildId) async {
    final raw = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    if (raw.isEmpty) {
      setState(() => _error = 'Channel name is required.');
      return;
    }
    final normalized = raw
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'[^a-z0-9\-]'), '');
    final name = normalized.isEmpty ? raw : normalized;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final Channel channel = await context
          .read<ChannelsRepository>()
          .createChannel(
            name: name,
            description: description,
            guildId: guildId,
          );
      if (!mounted) return;
      Navigator.of(context).pop(channel);
    } catch (e) {
      if (!mounted) return;
      if (e is ApiException) {
        setState(() => _error = e.message);
      } else {
        setState(() => _error = 'Failed to create channel.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final map = args is Map ? args : null;
    final guildId = map?['guildId']?.toString();
    final guildName = map?['guildName']?.toString();

    return Scaffold(
      appBar: AppBar(title: const Text('Create channel')),
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
                    guildName == null
                        ? 'New channel'
                        : 'New channel in $guildName',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      if (guildId == null) return;
                      _create(guildId);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Channel name',
                      hintText: 'e.g. general',
                      prefixText: '# ',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    textInputAction: TextInputAction.done,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'What is this channel for?',
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
                    onPressed: _isLoading || guildId == null
                        ? null
                        : () => _create(guildId),
                    child: _isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Add channel'),
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
