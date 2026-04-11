import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/errors/failures.dart';
import '../../data/repositories/remote_repository.dart';
import 'server_provider.dart';
import 'package:flutter/foundation.dart';

class AdbState {
  final List<AdbDevice> devices;
  final bool isLoading;
  final String? error;
  final String? lastCommandOutput;
  final String? lastInstalledPackage;

  const AdbState({
    this.devices = const [],
    this.isLoading = false,
    this.error,
    this.lastCommandOutput,
    this.lastInstalledPackage,
  });

  AdbState copyWith({
    List<AdbDevice>? devices,
    bool? isLoading,
    String? error,
    String? lastCommandOutput,
    String? lastInstalledPackage,
  }) {
    return AdbState(
      devices: devices ?? this.devices,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastCommandOutput: lastCommandOutput,
      lastInstalledPackage: lastInstalledPackage,
    );
  }
}

final adbControllerProvider =
    StateNotifierProvider<AdbController, AdbState>((ref) {
  return AdbController(ref);
});

class AdbController extends StateNotifier<AdbState> {
  final Ref _ref;

  AdbController(this._ref) : super(const AdbState());

  Future<void> refreshDevices() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      final devices = await repo.fetchAdbDevices();
      state = state.copyWith(devices: devices, isLoading: false);
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Returns the package name on success (null if extraction failed or install failed).
  Future<String?> installApk(String filePath, {String? deviceId, String? workspaceId}) async {
    state = state.copyWith(isLoading: true, error: null, lastCommandOutput: null);
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      final result = await repo.installApk(filePath, deviceId: deviceId, workspaceId: workspaceId);
      state = state.copyWith(
        isLoading: false,
        lastCommandOutput: result.stdout,
        error: result.success ? null : result.stderr,
        lastInstalledPackage: result.success ? result.packageName : null,
      );
      return result.success ? result.packageName : null;
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return null;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  Future<bool> launchApp(String packageName, {String? activityName, String? deviceId}) async {
    state = state.copyWith(isLoading: true, error: null, lastCommandOutput: null);
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      final result = await repo.launchApp(packageName, activityName: activityName, deviceId: deviceId);
      state = state.copyWith(
        isLoading: false,
        lastCommandOutput: result.stdout,
        error: result.success ? null : result.stderr,
      );
      return result.success;
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> wirelessPair(String ip, int port, String pairingCode) async {
    state = state.copyWith(isLoading: true, error: null, lastCommandOutput: null);
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      final result = await repo.wirelessPair(ip, port, pairingCode);
      state = state.copyWith(
        isLoading: false,
        lastCommandOutput: result.stdout,
        error: result.success ? null : result.stderr,
      );
      if (result.success) await refreshDevices();
      return result.success;
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

// ─── iOS device management ───────────────────────────────────────────────────

class IosState {
  final List<IosDevice> devices;
  final bool isLoading;
  final String? error;
  final String? lastCommandOutput;

  const IosState({
    this.devices = const [],
    this.isLoading = false,
    this.error,
    this.lastCommandOutput,
  });

  IosState copyWith({
    List<IosDevice>? devices,
    bool? isLoading,
    String? error,
    String? lastCommandOutput,
  }) {
    return IosState(
      devices: devices ?? this.devices,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastCommandOutput: lastCommandOutput,
    );
  }
}

final iosControllerProvider = StateNotifierProvider<IosController, IosState>((ref) {
  return IosController(ref);
});

class IosController extends StateNotifier<IosState> {
  final Ref _ref;

  IosController(this._ref) : super(const IosState());

  Future<void> refreshDevices() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      final devices = await repo.fetchIosDevices();
      if (kDebugMode) {
        debugPrint('[IosController] refreshDevices: found ${devices.length} devices');
      }
      state = state.copyWith(devices: devices, isLoading: false);
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> installIpa(String filePath, {String? deviceId, String? workspaceId}) async {
    state = state.copyWith(isLoading: true, error: null, lastCommandOutput: null);
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      final result = await repo.installIpa(filePath, deviceId: deviceId, workspaceId: workspaceId);
      state = state.copyWith(
        isLoading: false,
        lastCommandOutput: result.stdout,
        error: result.success ? null : result.stderr,
      );
      return result.success;
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}
