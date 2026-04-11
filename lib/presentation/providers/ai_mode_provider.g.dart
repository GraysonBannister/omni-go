// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_mode_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$availableModesHash() => r'0a431bc371660d027d8d3e58bd0d6f5e1308c16b';

/// Provider that returns all available AI modes
///
/// Copied from [availableModes].
@ProviderFor(availableModes)
final availableModesProvider = AutoDisposeProvider<List<AIMode>>.internal(
  availableModes,
  name: r'availableModesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableModesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableModesRef = AutoDisposeProviderRef<List<AIMode>>;
String _$selectedModeIdHash() => r'7cf690b86df4ed3b6e8754096d2c5db038a07a9f';

/// Provider that returns the currently selected mode ID
///
/// Copied from [selectedModeId].
@ProviderFor(selectedModeId)
final selectedModeIdProvider = AutoDisposeProvider<String>.internal(
  selectedModeId,
  name: r'selectedModeIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedModeIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedModeIdRef = AutoDisposeProviderRef<String>;
String _$isModeLoadingHash() => r'6fe8fc12b174fc788c50a1ab9fe4fb7fb1cb44fa';

/// Provider that returns true if the mode selector is loading
/// (always false since modes are statically defined)
///
/// Copied from [isModeLoading].
@ProviderFor(isModeLoading)
final isModeLoadingProvider = AutoDisposeProvider<bool>.internal(
  isModeLoading,
  name: r'isModeLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isModeLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsModeLoadingRef = AutoDisposeProviderRef<bool>;
String _$selectedModeHash() => r'aa6293146039727eb5166158ccada2b27ef5cb6a';

/// Provider for the currently selected AI mode
/// Uses keepAlive to persist across screens
///
/// Copied from [SelectedMode].
@ProviderFor(SelectedMode)
final selectedModeProvider = NotifierProvider<SelectedMode, AIMode>.internal(
  SelectedMode.new,
  name: r'selectedModeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedMode = Notifier<AIMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
