// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$remoteRepositoryHash() => r'1196d627fa8c7a37411026c15e725d2c6097af7e';

/// See also [remoteRepository].
@ProviderFor(remoteRepository)
final remoteRepositoryProvider = AutoDisposeProvider<RemoteRepository>.internal(
  remoteRepository,
  name: r'remoteRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$remoteRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RemoteRepositoryRef = AutoDisposeProviderRef<RemoteRepository>;
String _$serverConnectionHash() => r'dfd0a6b84b24a5006cbacf3b046ccc1f6880aee1';

/// See also [ServerConnection].
@ProviderFor(ServerConnection)
final serverConnectionProvider =
    NotifierProvider<ServerConnection, ServerConfig>.internal(
  ServerConnection.new,
  name: r'serverConnectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$serverConnectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ServerConnection = Notifier<ServerConfig>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
