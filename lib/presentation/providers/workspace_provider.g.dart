// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workspaceFoldersHash() => r'ce7fd05c2ea503dd08e1d584507ceba7fb511b1d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for workspace folders
///
/// Copied from [workspaceFolders].
@ProviderFor(workspaceFolders)
const workspaceFoldersProvider = WorkspaceFoldersFamily();

/// Provider for workspace folders
///
/// Copied from [workspaceFolders].
class WorkspaceFoldersFamily extends Family<AsyncValue<List<WorkspaceFolder>>> {
  /// Provider for workspace folders
  ///
  /// Copied from [workspaceFolders].
  const WorkspaceFoldersFamily();

  /// Provider for workspace folders
  ///
  /// Copied from [workspaceFolders].
  WorkspaceFoldersProvider call(
    String sharedId,
  ) {
    return WorkspaceFoldersProvider(
      sharedId,
    );
  }

  @override
  WorkspaceFoldersProvider getProviderOverride(
    covariant WorkspaceFoldersProvider provider,
  ) {
    return call(
      provider.sharedId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'workspaceFoldersProvider';
}

/// Provider for workspace folders
///
/// Copied from [workspaceFolders].
class WorkspaceFoldersProvider
    extends AutoDisposeFutureProvider<List<WorkspaceFolder>> {
  /// Provider for workspace folders
  ///
  /// Copied from [workspaceFolders].
  WorkspaceFoldersProvider(
    String sharedId,
  ) : this._internal(
          (ref) => workspaceFolders(
            ref as WorkspaceFoldersRef,
            sharedId,
          ),
          from: workspaceFoldersProvider,
          name: r'workspaceFoldersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workspaceFoldersHash,
          dependencies: WorkspaceFoldersFamily._dependencies,
          allTransitiveDependencies:
              WorkspaceFoldersFamily._allTransitiveDependencies,
          sharedId: sharedId,
        );

  WorkspaceFoldersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sharedId,
  }) : super.internal();

  final String sharedId;

  @override
  Override overrideWith(
    FutureOr<List<WorkspaceFolder>> Function(WorkspaceFoldersRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkspaceFoldersProvider._internal(
        (ref) => create(ref as WorkspaceFoldersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sharedId: sharedId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<WorkspaceFolder>> createElement() {
    return _WorkspaceFoldersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkspaceFoldersProvider && other.sharedId == sharedId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sharedId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WorkspaceFoldersRef
    on AutoDisposeFutureProviderRef<List<WorkspaceFolder>> {
  /// The parameter `sharedId` of this provider.
  String get sharedId;
}

class _WorkspaceFoldersProviderElement
    extends AutoDisposeFutureProviderElement<List<WorkspaceFolder>>
    with WorkspaceFoldersRef {
  _WorkspaceFoldersProviderElement(super.provider);

  @override
  String get sharedId => (origin as WorkspaceFoldersProvider).sharedId;
}

String _$currentWorkingDirectoryHash() =>
    r'61f214473e45e0a7414620e0e8364a24d1bbebd6';

/// Provider for the current working directory (selected folder of active workspace)
///
/// Copied from [currentWorkingDirectory].
@ProviderFor(currentWorkingDirectory)
final currentWorkingDirectoryProvider =
    AutoDisposeFutureProvider<String?>.internal(
  currentWorkingDirectory,
  name: r'currentWorkingDirectoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentWorkingDirectoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentWorkingDirectoryRef = AutoDisposeFutureProviderRef<String?>;
String _$isWorkspacesLoadingHash() =>
    r'e447fa8ea5a320f8b1ee9aec51c84b8c11b8b380';

/// Provider that returns true if workspaces are loading
///
/// Copied from [isWorkspacesLoading].
@ProviderFor(isWorkspacesLoading)
final isWorkspacesLoadingProvider = AutoDisposeProvider<bool>.internal(
  isWorkspacesLoading,
  name: r'isWorkspacesLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isWorkspacesLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsWorkspacesLoadingRef = AutoDisposeProviderRef<bool>;
String _$activeWorkspaceNameHash() =>
    r'14b0d366d4505e442708c77fde5a7268f2db9a63';

/// Provider that returns the active workspace name
///
/// Copied from [activeWorkspaceName].
@ProviderFor(activeWorkspaceName)
final activeWorkspaceNameProvider = AutoDisposeFutureProvider<String?>.internal(
  activeWorkspaceName,
  name: r'activeWorkspaceNameProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeWorkspaceNameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveWorkspaceNameRef = AutoDisposeFutureProviderRef<String?>;
String _$hasMultipleWorkspacesHash() =>
    r'2e7f0516ad36418379b4402c37f8439e172b4a45';

/// Provider that returns whether we have multiple workspaces available
///
/// Copied from [hasMultipleWorkspaces].
@ProviderFor(hasMultipleWorkspaces)
final hasMultipleWorkspacesProvider = AutoDisposeProvider<bool>.internal(
  hasMultipleWorkspaces,
  name: r'hasMultipleWorkspacesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasMultipleWorkspacesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasMultipleWorkspacesRef = AutoDisposeProviderRef<bool>;
String _$workspaceCountHash() => r'43882c2fd4f79e2ba6568d1c77d6c63b19b65b19';

/// Provider that returns the count of available workspaces
///
/// Copied from [workspaceCount].
@ProviderFor(workspaceCount)
final workspaceCountProvider = AutoDisposeProvider<int>.internal(
  workspaceCount,
  name: r'workspaceCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workspaceCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WorkspaceCountRef = AutoDisposeProviderRef<int>;
String _$availableWorkspacesHash() =>
    r'b271331577c0fef2bd85467ab0263a95c7198b46';

/// Provider for the list of available workspaces
///
/// Copied from [AvailableWorkspaces].
@ProviderFor(AvailableWorkspaces)
final availableWorkspacesProvider = AutoDisposeAsyncNotifierProvider<
    AvailableWorkspaces, List<Workspace>>.internal(
  AvailableWorkspaces.new,
  name: r'availableWorkspacesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableWorkspacesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AvailableWorkspaces = AutoDisposeAsyncNotifier<List<Workspace>>;
String _$currentWorkspaceHash() => r'eb937dcbf2207a3a0ac630d26cbcd21a22c044ad';

/// Provider for the currently active workspace
///
/// Copied from [CurrentWorkspace].
@ProviderFor(CurrentWorkspace)
final currentWorkspaceProvider =
    AsyncNotifierProvider<CurrentWorkspace, Workspace?>.internal(
  CurrentWorkspace.new,
  name: r'currentWorkspaceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentWorkspaceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentWorkspace = AsyncNotifier<Workspace?>;
String _$selectedWorkspaceFolderHash() =>
    r'e35c71e762b576b84a7d031a44d987d65a0c107e';

/// Provider for the currently selected folder within the active workspace
/// This allows users to switch between project folders in a multi-folder workspace
///
/// Copied from [SelectedWorkspaceFolder].
@ProviderFor(SelectedWorkspaceFolder)
final selectedWorkspaceFolderProvider =
    AsyncNotifierProvider<SelectedWorkspaceFolder, WorkspaceFolder?>.internal(
  SelectedWorkspaceFolder.new,
  name: r'selectedWorkspaceFolderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedWorkspaceFolderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedWorkspaceFolder = AsyncNotifier<WorkspaceFolder?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
