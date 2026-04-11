import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../config/constants.dart';
import '../../data/models/ai_model.dart';
import '../../data/repositories/remote_repository.dart';
import 'server_provider.dart';

part 'model_provider.g.dart';

const _secureStorage = FlutterSecureStorage();

/// Provider for the list of available AI models
@riverpod
class AvailableModels extends _$AvailableModels {
  @override
  Future<List<AIModel>> build() async {
    final repository = ref.watch(remoteRepositoryProvider);
    return repository.fetchAvailableModels();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(remoteRepositoryProvider);
      final models = await repository.fetchAvailableModels();
      state = AsyncData(models);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}

/// Provider for the currently selected model
@Riverpod(keepAlive: true)
class SelectedModel extends _$SelectedModel {
  @override
  AIModel? build() {
    _loadSavedModel();
    return null;
  }

  Future<void> _loadSavedModel() async {
    try {
      final modelId = await _secureStorage.read(key: StorageKeys.selectedModel);
      final provider = await _secureStorage.read(key: StorageKeys.selectedProvider);

      if (modelId != null && provider != null) {
        // Try to find the model in defaults first
        final model = DefaultModels.all.firstWhere(
          (m) => m.id == modelId && m.provider == provider,
          orElse: () => AIModel(
            id: modelId,
            name: modelId,
            provider: provider,
          ),
        );
        state = model;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to load saved model: $e');
      }
    }
  }

  Future<void> _saveModel() async {
    if (state == null) return;
    try {
      await _secureStorage.write(key: StorageKeys.selectedModel, value: state!.id);
      await _secureStorage.write(key: StorageKeys.selectedProvider, value: state!.provider);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to save model: $e');
      }
    }
  }

  void selectModel(AIModel model) {
    state = model;
    _saveModel();
  }

  void clear() {
    state = null;
    _secureStorage.delete(key: StorageKeys.selectedModel);
    _secureStorage.delete(key: StorageKeys.selectedProvider);
  }

  String? get modelId => state?.id;
  String? get provider => state?.provider;
}

/// Provider for models grouped by provider
@riverpod
Future<List<AIProvider>> modelsByProvider(ModelsByProviderRef ref) async {
  final models = await ref.watch(availableModelsProvider.future);

  final providerMap = <String, List<AIModel>>{};
  for (final model in models) {
    if (model.isAvailable) {
      providerMap.putIfAbsent(model.provider, () => []).add(model);
    }
  }

  return providerMap.entries.map((entry) {
    return AIProvider(
      id: entry.key,
      name: _providerDisplayName(entry.key),
      models: entry.value,
    );
  }).toList();
}

/// Provider for the currently selected provider info
@riverpod
Future<AIProvider?> selectedProviderInfo(SelectedProviderInfoRef ref) async {
  final selectedModel = ref.watch(selectedModelProvider);
  if (selectedModel == null) return null;

  final providers = await ref.watch(modelsByProviderProvider.future);
  return providers.firstWhere(
    (p) => p.id == selectedModel.provider,
    orElse: () => AIProvider(
      id: selectedModel.provider,
      name: _providerDisplayName(selectedModel.provider),
      models: [selectedModel],
    ),
  );
}

String _providerDisplayName(String providerId) {
  switch (providerId.toLowerCase()) {
    case 'anthropic':
      return 'Anthropic';
    case 'openai':
      return 'OpenAI';
    case 'google':
      return 'Google';
    case 'mistral':
      return 'Mistral';
    case 'groq':
      return 'Groq';
    case 'xai':
      return 'xAI';
    case 'bedrock':
      return 'AWS Bedrock';
    case 'moonshot':
      return 'Moonshot / Kimi';
    default:
      return providerId.substring(0, 1).toUpperCase() + providerId.substring(1);
  }
}

/// Provider that returns true if models are loading
@riverpod
bool isModelsLoading(IsModelsLoadingRef ref) {
  final modelsAsync = ref.watch(availableModelsProvider);
  return modelsAsync.isLoading;
}

/// Provider that returns the first available model as default
@riverpod
AIModel? defaultModel(DefaultModelRef ref) {
  final modelsAsync = ref.watch(availableModelsProvider);
  return modelsAsync.when(
    data: (models) => models.isNotEmpty ? models.first : null,
    loading: () => DefaultModels.all.first,
    error: (_, __) => DefaultModels.all.first,
  );
}
