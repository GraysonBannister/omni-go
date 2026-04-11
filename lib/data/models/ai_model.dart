import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_model.freezed.dart';
part 'ai_model.g.dart';

@freezed
class AIModel with _$AIModel {
  const factory AIModel({
    required String id,
    required String name,
    required String provider,
    String? description,
    @JsonKey(name: 'available') @Default(true) bool isAvailable,
    List<String>? aliases,
  }) = _AIModel;

  factory AIModel.fromJson(Map<String, dynamic> json) =>
      _$AIModelFromJson(json);
}

/// Provider information for grouping models
@freezed
class AIProvider with _$AIProvider {
  const factory AIProvider({
    required String id,
    required String name,
    required List<AIModel> models,
    @JsonKey(name: 'available') @Default(true) bool isAvailable,
  }) = _AIProvider;

  factory AIProvider.fromJson(Map<String, dynamic> json) =>
      _$AIProviderFromJson(json);
}

/// Default models to use as fallback when server fetch fails
class DefaultModels {
  static const List<AIModel> all = [
    // Anthropic
    AIModel(
      id: 'claude-3-5-sonnet',
      name: 'Claude 3.5 Sonnet',
      provider: 'anthropic',
      description: 'Balanced intelligence and speed',
    ),
    AIModel(
      id: 'claude-3-opus',
      name: 'Claude 3 Opus',
      provider: 'anthropic',
      description: 'Most capable model for complex tasks',
    ),
    AIModel(
      id: 'claude-3-haiku',
      name: 'Claude 3 Haiku',
      provider: 'anthropic',
      description: 'Fastest responses',
    ),
    // OpenAI
    AIModel(
      id: 'gpt-4o',
      name: 'GPT-4o',
      provider: 'openai',
      description: 'Multimodal flagship model',
    ),
    AIModel(
      id: 'gpt-4o-mini',
      name: 'GPT-4o Mini',
      provider: 'openai',
      description: 'Fast and cost-effective',
    ),
    AIModel(
      id: 'o3-mini',
      name: 'o3-mini',
      provider: 'openai',
      description: 'Reasoning model',
    ),
    // Google
    AIModel(
      id: 'gemini-1.5-pro',
      name: 'Gemini 1.5 Pro',
      provider: 'google',
      description: 'Google\'s most capable model',
    ),
    AIModel(
      id: 'gemini-1.5-flash',
      name: 'Gemini 1.5 Flash',
      provider: 'google',
      description: 'Fast and efficient',
    ),
    // Mistral
    AIModel(
      id: 'mistral-large',
      name: 'Mistral Large',
      provider: 'mistral',
      description: 'Most capable Mistral model',
    ),
    AIModel(
      id: 'codestral',
      name: 'Codestral',
      provider: 'mistral',
      description: 'Optimized for code',
    ),
    // Groq
    AIModel(
      id: 'llama-3.1-70b',
      name: 'Llama 3.1 70B',
      provider: 'groq',
      description: 'Fast inference via Groq',
    ),
    AIModel(
      id: 'mixtral-8x7b',
      name: 'Mixtral 8x7B',
      provider: 'groq',
      description: 'Mixture of experts model',
    ),
    // XAI
    AIModel(
      id: 'grok-2',
      name: 'Grok 2',
      provider: 'xai',
      description: 'xAI\'s latest model',
    ),
    // Moonshot
    AIModel(
      id: 'kimi-k2-5',
      name: 'Kimi K2.5',
      provider: 'moonshot',
      description: 'Moonshot Kimi K2.5 - Long context model',
    ),
    AIModel(
      id: 'kimi-k1-5',
      name: 'Kimi K1.5',
      provider: 'moonshot',
      description: 'Moonshot Kimi K1.5 - Reasoning model',
    ),
  ];

  static List<AIProvider> get providers {
    final providerMap = <String, List<AIModel>>{};
    for (final model in all) {
      providerMap.putIfAbsent(model.provider, () => []).add(model);
    }
    return providerMap.entries.map((entry) => AIProvider(
      id: entry.key,
      name: _providerDisplayName(entry.key),
      models: entry.value,
    )).toList();
  }

  static String _providerDisplayName(String providerId) {
    switch (providerId) {
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
      default:
        return providerId.substring(0, 1).toUpperCase() + providerId.substring(1);
    }
  }

  static AIModel? findById(String id) {
    return all.firstWhere(
      (model) => model.id == id || (model.aliases?.contains(id) ?? false),
      orElse: () => null as AIModel,
    );
  }
}
