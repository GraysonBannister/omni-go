import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/constants.dart';
import '../../data/models/change_review_settings.dart';
import '../../presentation/providers/server_provider.dart';
import '../../presentation/providers/settings_provider.dart';
import 'connect_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverConnection = ref.watch(serverConnectionProvider);
    final changeReviewSettings = ref.watch(changeReviewSettingsProvider);
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _buildSection(context, title: 'Appearance', children: [
            ListTile(
              leading: const Icon(Icons.brightness_medium_outlined),
              title: const Text('Theme'),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(value: ThemeMode.system, label: Text('System')),
                    ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                    ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (selection) => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(selection.first),
                ),
              ),
            ),
          ]),
          _buildSection(context, title: 'Connection', children: [
            ListTile(
              leading: Icon(
                serverConnection.isConnected ? Icons.check_circle : Icons.error_outline,
                color: serverConnection.isConnected ? Colors.green : theme.colorScheme.error,
              ),
              title: Text(serverConnection.isConnected ? 'Connected' : 'Disconnected',
                  style: theme.textTheme.titleMedium),
              subtitle: serverConnection.isConnected ? Text(serverConnection.url) : const Text('Not connected'),
            ),
          ]),
          if (serverConnection.isConnected)
            _buildSection(context, title: 'Change Review', children: [
              ListTile(
                leading: const Icon(Icons.rate_review),
                title: const Text('Enable Change Review'),
                subtitle: const Text('Review file changes before applying them'),
                trailing: changeReviewSettings.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Switch(
                        value: changeReviewSettings.enabled,
                        onChanged: (value) => ref
                            .read(changeReviewSettingsProvider.notifier)
                            .toggleEnabled(value),
                      ),
              ),
              if (changeReviewSettings.enabled)
                ListTile(
                  leading: const Icon(Icons.filter_list),
                  title: const Text('Review Mode'),
                  subtitle: Text(
                    changeReviewSettings.mode == ChangeReviewMode.all
                        ? 'Review all changes'
                        : 'Review only dangerous changes (Write, MultiFileEdit)',
                  ),
                  trailing: DropdownButton<ChangeReviewMode>(
                    value: changeReviewSettings.mode,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: ChangeReviewMode.all,
                        child: Text('All Changes'),
                      ),
                      DropdownMenuItem(
                        value: ChangeReviewMode.dangerous,
                        child: Text('Dangerous Only'),
                      ),
                    ],
                    onChanged: (mode) {
                      if (mode != null) {
                        ref
                            .read(changeReviewSettingsProvider.notifier)
                            .setMode(mode);
                      }
                    },
                  ),
                ),
              if (changeReviewSettings.error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Error: ${changeReviewSettings.error}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
            ]),
          _buildSection(context, title: 'Actions', children: [
            if (serverConnection.isConnected)
              ListTile(
                leading: Icon(Icons.logout, color: theme.colorScheme.error),
                title: Text('Disconnect', style: TextStyle(color: theme.colorScheme.error)),
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Disconnect?'),
                      content: const Text('This will disconnect from the current server.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
                          child: const Text('Disconnect'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    await ref.read(serverConnectionProvider.notifier).disconnect();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const ConnectScreen()),
                      );
                    }
                  }
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Connect to Server'),
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ConnectScreen()),
                ),
              ),
          ]),
          _buildSection(context, title: 'About', children: [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('App Name'),
              subtitle: Text(AppConstants.appName),
            ),
            ListTile(
              leading: const Icon(Icons.numbers),
              title: const Text('Version'),
              subtitle: Text(AppConstants.appVersion),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Widget> children}) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(title.toUpperCase(),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              )),
        ),
        ...children,
        const Divider(),
      ],
    );
  }
}
