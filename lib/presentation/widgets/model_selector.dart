import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ai_model.dart';
import '../../data/repositories/remote_repository.dart';
import '../providers/chat_provider.dart';
import '../providers/model_provider.dart';
import '../providers/server_provider.dart';

/// Compact chip showing current model that opens selector when tapped
class ModelSelectorChip extends ConsumerWidget {
  final VoidCallback? onModelChanged;

  const ModelSelectorChip({super.key, this.onModelChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedModel = ref.watch(selectedModelProvider);
    final isLoading = ref.watch(isModelsLoadingProvider);

    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    final displayText = selectedModel?.name ?? 'Default Model';
    final providerName = selectedModel?.provider ?? '';

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 140),
      child: ActionChip(
        avatar: _getProviderIcon(providerName, theme),
        label: Text(
          displayText,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        side: BorderSide.none,
        onPressed: () => _showModelSelector(context, ref),
      ),
    );
  }

  Widget? _getProviderIcon(String provider, ThemeData theme) {
    IconData iconData;
    switch (provider.toLowerCase()) {
      case 'anthropic':
        iconData = Icons.auto_awesome;
        break;
      case 'openai':
        iconData = Icons.chat_bubble;
        break;
      case 'google':
        iconData = Icons.search;
        break;
      case 'mistral':
        iconData = Icons.wind_power;
        break;
      case 'groq':
        iconData = Icons.bolt;
        break;
      case 'xai':
        iconData = Icons.rocket_launch;
        break;
      case 'moonshot':
        iconData = Icons.nightlight_round;
        break;
      default:
        iconData = Icons.smart_toy;
    }

    return Icon(
      iconData,
      size: 16,
      color: theme.colorScheme.primary,
    );
  }

  void _showModelSelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      builder: (context) => const ModelSelectorSheet(),
    );
  }
}

/// Full model selector bottom sheet
class ModelSelectorSheet extends ConsumerStatefulWidget {
  const ModelSelectorSheet({super.key});

  @override
  ConsumerState<ModelSelectorSheet> createState() => _ModelSelectorSheetState();
}

class _ModelSelectorSheetState extends ConsumerState<ModelSelectorSheet> {
  String? _expandedProvider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final providersAsync = ref.watch(modelsByProviderProvider);
    final selectedModel = ref.watch(selectedModelProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
                ),
              ),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Select AI Model',
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          ref.read(availableModelsProvider.notifier).refresh();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  if (selectedModel != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.zero,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: theme.colorScheme.onPrimaryContainer,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Currently using: ${selectedModel.name} (${selectedModel.provider})',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Provider list
            Expanded(
              child: providersAsync.when(
                data: (providers) {
                  if (providers.isEmpty) {
                    return const Center(
                      child: Text('No models available'),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: providers.length,
                    itemBuilder: (context, index) {
                      final provider = providers[index];
                      return _ProviderExpansionTile(
                        provider: provider,
                        isExpanded: _expandedProvider == provider.id,
                        selectedModel: selectedModel,
                        onToggle: () {
                          setState(() {
                            _expandedProvider = _expandedProvider == provider.id
                                ? null
                                : provider.id;
                          });
                        },
                        onModelSelected: (model) async {
                          ref.read(selectedModelProvider.notifier).selectModel(model);
                          // Update the active conversation on the server
                          final chatController = ref.read(chatControllerProvider);
                          if (chatController.id.isNotEmpty) {
                            try {
                              final repo = ref.read(remoteRepositoryProvider);
                              await repo.switchModel(chatController.id, model.id, model.provider);
                              if (kDebugMode) {
                                debugPrint('[ModelSelector] Switched server model to ${model.id} (${model.provider})');
                              }
                            } catch (e) {
                              if (kDebugMode) {
                                debugPrint('[ModelSelector] Failed to switch server model: $e');
                              }
                            }
                          }
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load models',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(availableModelsProvider.notifier).refresh();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProviderExpansionTile extends StatelessWidget {
  final AIProvider provider;
  final bool isExpanded;
  final AIModel? selectedModel;
  final VoidCallback onToggle;
  final Function(AIModel) onModelSelected;

  const _ProviderExpansionTile({
    required this.provider,
    required this.isExpanded,
    required this.selectedModel,
    required this.onToggle,
    required this.onModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        ListTile(
          leading: _getProviderAvatar(provider.id, theme),
          title: Text(provider.name),
          subtitle: Text('${provider.models.length} models'),
          trailing: Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          onTap: onToggle,
        ),
        if (isExpanded)
          Container(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            child: Column(
              children: provider.models.map((model) {
                final isSelected = selectedModel?.id == model.id;
                return ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.only(left: 72, right: 16),
                  title: Text(
                    model.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : null,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  subtitle: model.description != null
                      ? Text(
                          model.description!,
                          style: theme.textTheme.bodySmall,
                        )
                      : null,
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.primary,
                          size: 20,
                        )
                      : null,
                  onTap: () => onModelSelected(model),
                );
              }).toList(),
            ),
          ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _getProviderAvatar(String providerId, ThemeData theme) {
    IconData iconData;
    Color color;

    switch (providerId.toLowerCase()) {
      case 'anthropic':
        iconData = Icons.auto_awesome;
        color = Colors.orange;
        break;
      case 'openai':
        iconData = Icons.chat_bubble;
        color = Colors.green;
        break;
      case 'google':
        iconData = Icons.search;
        color = Colors.blue;
        break;
      case 'mistral':
        iconData = Icons.wind_power;
        color = Colors.cyan;
        break;
      case 'groq':
        iconData = Icons.bolt;
        color = Colors.amber;
        break;
      case 'xai':
        iconData = Icons.rocket_launch;
        color = Colors.red;
        break;
      case 'moonshot':
        iconData = Icons.nightlight_round;
        color = Colors.indigo;
        break;
      default:
        iconData = Icons.smart_toy;
        color = theme.colorScheme.primary;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      child: Icon(iconData, color: color, size: 20),
    );
  }
}
