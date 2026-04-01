import 'package:causeries_client/features/guilds/domain/entities/channel.dart';
import 'package:causeries_client/features/guilds/domain/entities/guild.dart';
import 'package:causeries_client/features/guilds/domain/entities/guild_member.dart';
import 'package:causeries_client/features/guilds/domain/repositories/channels_repository.dart';
import 'package:causeries_client/features/guilds/domain/repositories/guilds_repository.dart';
import 'package:causeries_client/features/guilds/presentation/views/channel_create_screen.dart';
import 'package:causeries_client/features/guilds/presentation/views/guild_create_screen.dart';
import 'package:causeries_client/features/guilds/presentation/viewmodels/guild_home_view_model.dart';
import 'package:causeries_client/core/network/api_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessage {
  final String id;
  final String author;
  final String content;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
  });
}

class GuildHomeScreen extends StatefulWidget {
  const GuildHomeScreen({super.key});

  @override
  State<GuildHomeScreen> createState() => _GuildHomeScreenState();
}

class _GuildHomeScreenState extends State<GuildHomeScreen> {
  final TextEditingController _composerController = TextEditingController();

  final Map<String, List<ChatMessage>> _messagesByChannelId = {};
  final Set<String> _deletingChannelIds = {};
  final Set<String> _deletingGuildIds = {};

  bool _isMobilePlatform(BuildContext context) {
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.android || platform == TargetPlatform.iOS;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<GuildHomeViewModel>().init();
    });
  }

  @override
  void dispose() {
    _composerController.dispose();
    super.dispose();
  }

  List<ChatMessage> _messagesFor(Channel channel) {
    return _messagesByChannelId.putIfAbsent(channel.id, () {
      return [
        ChatMessage(
          id: 'm1_${channel.id}',
          author: 'System',
          content: 'Welcome to #${channel.name}',
          createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
        ),
      ];
    });
  }

  Future<void> _openCreateGuild() async {
    final res = await showDialog<Guild>(
      context: context,
      builder: (_) => const GuildCreateDialog(),
    );
    if (!mounted) return;
    if (res is! Guild) return;
    context.read<GuildHomeViewModel>().onGuildCreated(res);
  }

  Future<void> _deleteGuild(Guild guild) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final scheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: const Text('Delete guild?'),
          content: Text('This will delete ${guild.name}.'),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: scheme.error,
                      foregroundColor: scheme.onError,
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;
    if (!mounted) return;
    if (_deletingGuildIds.contains(guild.id)) return;

    final guildsRepo = context.read<GuildsRepository>();
    final vm = context.read<GuildHomeViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _deletingGuildIds.add(guild.id));
    try {
      await guildsRepo.deleteGuild(guild.id);
      if (!mounted) return;

      await vm.refreshGuilds();
      if (!mounted) return;

      messenger.showSnackBar(SnackBar(content: Text('Deleted ${guild.name}.')));
    } catch (e) {
      if (!mounted) return;
      final msg = (e is ApiException) ? e.message : 'Failed to delete guild.';
      messenger.showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) {
        setState(() => _deletingGuildIds.remove(guild.id));
      }
    }
  }

  Future<void> _openGuildActions(Guild guild, Offset globalPosition) async {
    if (_deletingGuildIds.contains(guild.id)) return;

    if (_isMobilePlatform(context)) {
      final action = await showModalBottomSheet<String>(
        context: context,
        showDragHandle: true,
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: const Text('Delete guild'),
                  onTap: () => Navigator.of(context).pop('delete'),
                ),
              ],
            ),
          );
        },
      );
      if (action == 'delete') {
        await _deleteGuild(guild);
      }
      return;
    }

    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromLTWH(globalPosition.dx, globalPosition.dy, 0, 0),
      Offset.zero & overlay.size,
    );

    final action = await showMenu<String>(
      context: context,
      position: position,
      items: const [
        PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
      ],
    );
    if (action == 'delete') {
      await _deleteGuild(guild);
    }
  }

  Future<void> _openCreateChannel() async {
    final vm = context.read<GuildHomeViewModel>();
    final guild = vm.selectedGuild;
    if (guild == null) return;

    final res = await showDialog<Channel>(
      context: context,
      builder: (_) =>
          ChannelCreateDialog(guildId: guild.id, guildName: guild.name),
    );
    if (!mounted) return;
    if (res is! Channel) return;
    vm.onChannelCreated(res);
  }

  Future<void> _deleteChannel(Channel channel) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final scheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: const Text('Delete channel?'),
          content: Text('This will delete #${channel.name}.'),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: scheme.error,
                      foregroundColor: scheme.onError,
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;
    if (!mounted) return;
    if (_deletingChannelIds.contains(channel.id)) return;

    final channelsRepo = context.read<ChannelsRepository>();
    final vm = context.read<GuildHomeViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _deletingChannelIds.add(channel.id));
    try {
      await channelsRepo.deleteChannel(channel.id);
      if (!mounted) return;

      vm.onChannelDeleted(channel.id);
      setState(() {
        _messagesByChannelId.remove(channel.id);
      });

      messenger.showSnackBar(
        SnackBar(content: Text('Deleted #${channel.name}.')),
      );
    } catch (e) {
      if (!mounted) return;
      final msg = (e is ApiException) ? e.message : 'Failed to delete channel.';
      messenger.showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) {
        setState(() => _deletingChannelIds.remove(channel.id));
      }
    }
  }

  void _sendMessage() {
    final channel = context.read<GuildHomeViewModel>().selectedChannel;
    if (channel == null) return;
    final content = _composerController.text.trim();
    if (content.isEmpty) return;

    setState(() {
      _messagesFor(channel).add(
        ChatMessage(
          id: 'm_${DateTime.now().microsecondsSinceEpoch}',
          author: 'You',
          content: content,
          createdAt: DateTime.now(),
        ),
      );
      _composerController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GuildHomeViewModel>();
    final guilds = vm.guilds;
    final selectedGuild = vm.selectedGuild;
    final channels = vm.channels;
    final members = vm.members;
    final selectedChannel = vm.selectedChannel;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 980;

        final selectedGuildIndex = selectedGuild == null
            ? -1
            : guilds.indexWhere((g) => g.id == selectedGuild.id);

        Widget buildRow(BuildContext scaffoldContext) {
          return Row(
            children: [
              _GuildRail(
                guilds: guilds,
                selectedIndex: selectedGuildIndex,
                onSelect: (i) => vm.selectGuild(guilds[i]),
                onCreateGuild: _openCreateGuild,
                deletingGuildIds: _deletingGuildIds,
                onOpenGuildActions: _openGuildActions,
              ),
              if (isWide)
                _ChannelSidebar(
                  guildName: selectedGuild?.name,
                  channels: channels,
                  isLoading: vm.isLoadingDetails,
                  selectedChannelId: selectedChannel?.id,
                  onCreateChannel: _openCreateChannel,
                  deletingChannelIds: _deletingChannelIds,
                  onDeleteChannel: _deleteChannel,
                  onSelectChannel: (id) {
                    final ch = channels.firstWhere((c) => c.id == id);
                    vm.selectChannel(ch);
                  },
                ),
              Expanded(
                child: _ChannelChatPane(
                  guildName: selectedGuild?.name,
                  channel: selectedChannel,
                  isLoadingGuilds: vm.isLoadingGuilds,
                  errorMessage: vm.errorMessage,
                  onRetry: () => vm.refreshGuilds(),
                  messages: selectedChannel == null
                      ? const []
                      : _messagesFor(selectedChannel),
                  composerController: _composerController,
                  onSend: _sendMessage,
                  onOpenChannelsDrawer: isWide
                      ? null
                      : () => Scaffold.of(scaffoldContext).openDrawer(),
                  onOpenMembersDrawer: isWide
                      ? null
                      : () => Scaffold.of(scaffoldContext).openEndDrawer(),
                ),
              ),
              if (isWide)
                _MembersSidebar(
                  members: members,
                  isLoading: vm.isLoadingDetails,
                ),
            ],
          );
        }

        if (isWide) {
          return Scaffold(
            body: SafeArea(
              child: Builder(
                builder: (scaffoldContext) => buildRow(scaffoldContext),
              ),
            ),
          );
        }

        return Scaffold(
          drawer: Drawer(
            child: SafeArea(
              child: _ChannelSidebar(
                guildName: selectedGuild?.name,
                channels: channels,
                isLoading: vm.isLoadingDetails,
                selectedChannelId: selectedChannel?.id,
                onCreateChannel: _openCreateChannel,
                deletingChannelIds: _deletingChannelIds,
                onDeleteChannel: _deleteChannel,
                onSelectChannel: (id) {
                  final ch = channels.firstWhere((c) => c.id == id);
                  vm.selectChannel(ch);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          endDrawer: Drawer(
            child: SafeArea(
              child: _MembersSidebar(
                members: members,
                isLoading: vm.isLoadingDetails,
              ),
            ),
          ),
          body: SafeArea(
            child: Builder(
              builder: (scaffoldContext) => buildRow(scaffoldContext),
            ),
          ),
        );
      },
    );
  }
}

class _GuildRail extends StatelessWidget {
  final List<Guild> guilds;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onCreateGuild;
  final Set<String> deletingGuildIds;
  final void Function(Guild guild, Offset globalPosition) onOpenGuildActions;

  const _GuildRail({
    required this.guilds,
    required this.selectedIndex,
    required this.onSelect,
    required this.onCreateGuild,
    required this.deletingGuildIds,
    required this.onOpenGuildActions,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final platform = Theme.of(context).platform;
    final isMobile =
        platform == TargetPlatform.android || platform == TargetPlatform.iOS;

    return Container(
      width: 76,
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(right: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: guilds.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final g = guilds[index];
                final selected = index == selectedIndex;
                final isDeleting = deletingGuildIds.contains(g.id);
                return Tooltip(
                  message: g.name,
                  child: GestureDetector(
                    onSecondaryTapDown: (d) =>
                        onOpenGuildActions(g, d.globalPosition),
                    onLongPressStart: isMobile
                        ? (d) => onOpenGuildActions(g, d.globalPosition)
                        : null,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: isDeleting ? null : () => onSelect(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        curve: Curves.easeOut,
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: selected
                              ? scheme.primaryContainer.withValues(alpha: 0.6)
                              : scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(
                            selected ? 18 : 26,
                          ),
                          border: Border.all(
                            color: selected
                                ? scheme.primary
                                : scheme.outlineVariant,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: isDeleting
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _initials(g.name),
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: selected
                                          ? scheme.primary
                                          : scheme.onSurface,
                                    ),
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
            child: IconButton.filledTonal(
              onPressed: onCreateGuild,
              tooltip: 'Create guild',
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChannelSidebar extends StatelessWidget {
  final String? guildName;
  final List<Channel> channels;
  final bool isLoading;
  final String? selectedChannelId;
  final VoidCallback onCreateChannel;
  final Set<String> deletingChannelIds;
  final ValueChanged<Channel> onDeleteChannel;
  final ValueChanged<String> onSelectChannel;

  const _ChannelSidebar({
    required this.guildName,
    required this.channels,
    required this.isLoading,
    required this.selectedChannelId,
    required this.onCreateChannel,
    required this.deletingChannelIds,
    required this.onDeleteChannel,
    required this.onSelectChannel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(right: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    guildName ?? 'No guild',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Add channel',
                  onPressed: (guildName == null || isLoading)
                      ? null
                      : onCreateChannel,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
            child: Text(
              'Text channels',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: scheme.onSurfaceVariant,
                letterSpacing: 0.2,
              ),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (isLoading) {
                  return const Center(
                    child: SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    ),
                  );
                }

                if (guildName == null) {
                  return Center(
                    child: Text(
                      'Create or select a guild',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }

                final textChannels = channels.toList();
                if (textChannels.isEmpty) {
                  return Center(
                    child: Text(
                      'No channels yet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
                  itemCount: textChannels.length,
                  itemBuilder: (context, index) {
                    final c = textChannels[index];
                    final isDeleting = deletingChannelIds.contains(c.id);
                    final selected = c.id == selectedChannelId;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        dense: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: Icon(
                          Icons.tag,
                          size: 18,
                          color: selected
                              ? scheme.primary
                              : scheme.onSurfaceVariant,
                        ),
                        title: Text(c.name, overflow: TextOverflow.ellipsis),
                        selected: selected,
                        onTap: isDeleting ? null : () => onSelectChannel(c.id),
                        trailing: isDeleting
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : PopupMenuButton<String>(
                                tooltip: 'Channel actions',
                                onSelected: (value) {
                                  if (value == 'delete') onDeleteChannel(c);
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChannelChatPane extends StatelessWidget {
  final String? guildName;
  final Channel? channel;
  final bool isLoadingGuilds;
  final String? errorMessage;
  final VoidCallback onRetry;
  final List<ChatMessage> messages;
  final TextEditingController composerController;
  final VoidCallback onSend;
  final VoidCallback? onOpenChannelsDrawer;
  final VoidCallback? onOpenMembersDrawer;

  const _ChannelChatPane({
    required this.guildName,
    required this.channel,
    required this.isLoadingGuilds,
    required this.errorMessage,
    required this.onRetry,
    required this.messages,
    required this.composerController,
    required this.onSend,
    required this.onOpenChannelsDrawer,
    required this.onOpenMembersDrawer,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: scheme.surface,
            border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              if (onOpenChannelsDrawer != null)
                IconButton(
                  tooltip: 'Channels',
                  onPressed: onOpenChannelsDrawer,
                  icon: const Icon(Icons.menu),
                ),
              const Icon(Icons.tag, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  channel == null ? (guildName ?? 'Guilds') : channel!.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (onOpenMembersDrawer != null)
                IconButton(
                  tooltip: 'Members',
                  onPressed: onOpenMembersDrawer,
                  icon: const Icon(Icons.group_outlined),
                )
              else
                IconButton(
                  tooltip: 'Members',
                  onPressed: null,
                  icon: Icon(
                    Icons.group_outlined,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 170),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: isLoadingGuilds
                ? const Center(
                    key: ValueKey('loading'),
                    child: SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    ),
                  )
                : (errorMessage != null)
                ? _ErrorState(
                    key: const ValueKey('error'),
                    message: errorMessage!,
                    onRetry: onRetry,
                  )
                : (guildName == null)
                ? const _EmptyGuildState(key: ValueKey('no_guild'))
                : (channel == null)
                ? _EmptyChannelState(key: const ValueKey('empty'))
                : _MessageList(
                    key: ValueKey(channel!.id),
                    channelName: channel!.name,
                    messages: messages,
                  ),
          ),
        ),
        if (channel != null)
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            decoration: BoxDecoration(
              color: scheme.surface,
              border: Border(top: BorderSide(color: scheme.outlineVariant)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: composerController,
                    minLines: 1,
                    maxLines: 4,
                    onSubmitted: (_) => onSend(),
                    decoration: InputDecoration(
                      hintText: 'Message #${channel!.name}',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  tooltip: 'Send',
                  onPressed: onSend,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _MessageList extends StatelessWidget {
  final String channelName;
  final List<ChatMessage> messages;

  const _MessageList({
    super.key,
    required this.channelName,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return _EmptyChannelState(key: const ValueKey('empty_messages'));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final m = messages[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(radius: 18, child: Text(_initials(m.author))),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          m.author,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _time(m.createdAt),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(m.content),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyChannelState extends StatelessWidget {
  const _EmptyChannelState({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pick a channel',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Channels stay on the left. Members stay on the right. The middle changes based on what you open.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
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

class _EmptyGuildState extends StatelessWidget {
  const _EmptyGuildState({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: Icon(Icons.hub_outlined, color: scheme.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No guilds yet',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Create a guild to start. Your guild list will appear on the left rail.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
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

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ErrorState({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: scheme.errorContainer.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: Icon(Icons.error_outline, color: scheme.error),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Something went wrong',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          message,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        if (onRetry != null) ...[
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: onRetry,
                            child: const Text('Retry'),
                          ),
                        ],
                      ],
                    ),
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

class _MembersSidebar extends StatelessWidget {
  final List<GuildMember> members;
  final bool isLoading;

  const _MembersSidebar({required this.members, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(left: BorderSide(color: scheme.outlineVariant)),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
        children: [
          Text(
            'Members',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Center(
                child: SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
              ),
            )
          else ...[
            if (members.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'No members',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              )
            else ...[
              Text(
                'Members - ${members.length}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              for (final m in members) _MemberRow(name: m.username),
            ],
          ],
        ],
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  final String name;

  const _MemberRow({required this.name});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Stack(
            children: [CircleAvatar(radius: 16, child: Text(_initials(name)))],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

String _initials(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return '?';
  final parts = trimmed
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) {
    final w = parts.first;
    if (w.length == 1) return w.toUpperCase();
    return w.substring(0, 2).toUpperCase();
  }
  final a = parts.first.isEmpty ? '?' : parts.first[0];
  final b = parts[1].isEmpty ? '?' : parts[1][0];
  return (a + b).toUpperCase();
}

String _time(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}
