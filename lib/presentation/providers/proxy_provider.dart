import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/errors/failures.dart';
import '../../data/repositories/remote_repository.dart';
import 'server_provider.dart';

class ProxyState {
  final bool enabled;
  final List<ProxyPort> ports;
  final List<AvailableService> availableServices;
  final bool isLoading;
  final bool isScanning;
  final String? error;

  const ProxyState({
    this.enabled = false,
    this.ports = const [],
    this.availableServices = const [],
    this.isLoading = false,
    this.isScanning = false,
    this.error,
  });

  ProxyState copyWith({
    bool? enabled,
    List<ProxyPort>? ports,
    List<AvailableService>? availableServices,
    bool? isLoading,
    bool? isScanning,
    String? error,
  }) {
    return ProxyState(
      enabled: enabled ?? this.enabled,
      ports: ports ?? this.ports,
      availableServices: availableServices ?? this.availableServices,
      isLoading: isLoading ?? this.isLoading,
      isScanning: isScanning ?? this.isScanning,
      error: error,
    );
  }
}

final proxyControllerProvider =
    StateNotifierProvider<ProxyController, ProxyState>((ref) {
  return ProxyController(ref);
});

class ProxyController extends StateNotifier<ProxyState> {
  final Ref _ref;

  ProxyController(this._ref) : super(const ProxyState());

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      final result = await repo.fetchProxyList();
      state = state.copyWith(
        enabled: result.enabled,
        ports: result.ports,
        isLoading: false,
      );
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> registerPort(int port, {String? name}) async {
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      await repo.registerProxyPort(port, name: name);
      await refresh();
    } on Failure catch (e) {
      state = state.copyWith(error: e.message);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> unregisterPort(int port) async {
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      await repo.unregisterProxyPort(port);
      await refresh();
    } on Failure catch (e) {
      state = state.copyWith(error: e.message);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Scan for available localhost services on the host
  Future<void> scanForServices() async {
    state = state.copyWith(isScanning: true, error: null);
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      final result = await repo.scanForServices();
      state = state.copyWith(
        enabled: result.enabled,
        availableServices: result.available,
        isScanning: false,
      );
    } on Failure catch (e) {
      state = state.copyWith(isScanning: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isScanning: false, error: e.toString());
    }
  }

  /// Register a discovered service and open it
  Future<void> registerAndOpenPort(int port, String name, Function(int) onOpen) async {
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      await repo.registerProxyPort(port, name: name);
      await refresh();
      onOpen(port);
    } on Failure catch (e) {
      state = state.copyWith(error: e.message);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  String getProxyUrl(int port) {
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      return repo.getProxyUrl(port);
    } catch (_) {
      return '';
    }
  }

  Map<String, String> getProxyHeaders({String path = '/'}) {
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      return repo.getProxyHeaders(path: path);
    } catch (_) {
      return {};
    }
  }
}
