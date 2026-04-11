// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$modelsByProviderHash() => r'650df7dbba3a70853202a5ae7615b30aa5c17f68';

/// Provider for models grouped by provider
///
/// Copied from [modelsByProvider].
@ProviderFor(modelsByProvider)
final modelsByProviderProvider =
    AutoDisposeFutureProvider<List<AIProvider>>.internal(
  modelsByProvider,
  name: r'modelsByProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$modelsByProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ModelsByProviderRef = AutoDisposeFutureProviderRef<List<AIProvider>>;
String _$selectedProviderInfoHash() =>
    r'b34944d63454e094c9326a51221eb1a179ec9f74';

/// Provider for the currently selected provider info
///
/// Copied from [selectedProviderInfo].
@ProviderFor(selectedProviderInfo)
final selectedProviderInfoProvider =
    AutoDisposeFutureProvider<AIProvider?>.internal(
  selectedProviderInfo,
  name: r'selectedProviderInfoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedProviderInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedProviderInfoRef = AutoDisposeFutureProviderRef<AIProvider?>;
String _$isModelsLoadingHash() => r'5842c9ae5463e78ccd26c928a3a9475dbe329e56';

/// Provider that returns true if models are loading
///
/// Copied from [isModelsLoading].
@ProviderFor(isModelsLoading)
final isModelsLoadingProvider = AutoDisposeProvider<bool>.internal(
  isModelsLoading,
  name: r'isModelsLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isModelsLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsModelsLoadingRef = AutoDisposeProviderRef<bool>;
String _$defaultModelHash() => r'e894ce1fd4d5221fc851e535756c57d530551c9a';

/// Provider that returns the first available model as default
///
/// Copied from [defaultModel].
@ProviderFor(defaultModel)
final defaultModelProvider = AutoDisposeProvider<AIModel?>.internal(
  defaultModel,
  name: r'defaultModelProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$defaultModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DefaultModelRef = AutoDisposeProviderRef<AIModel?>;
String _$availableModelsHash() => r'b3d18ad43f95869572df1786e1e140f08ed57518';

/// Provider for the list of available AI models
///
/// Copied from [AvailableModels].
@ProviderFor(AvailableModels)
final availableModelsProvider =
    AutoDisposeAsyncNotifierProvider<AvailableModels, List<AIModel>>.internal(
  AvailableModels.new,
  name: r'availableModelsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableModelsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AvailableModels = AutoDisposeAsyncNotifier<List<AIModel>>;
String _$selectedModelHash() => r'36faad930145036899afb6b82ac80d492baee48c';

/// Provider for the currently selected model
///
/// Copied from [SelectedModel].
@ProviderFor(SelectedModel)
final selectedModelProvider =
    NotifierProvider<SelectedModel, AIModel?>.internal(
  SelectedModel.new,
  name: r'selectedModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedModel = Notifier<AIModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
