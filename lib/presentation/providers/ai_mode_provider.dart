import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../config/constants.dart';
import '../../data/models/ai_mode.dart';

part 'ai_mode_provider.g.dart';

const _secureStorage = FlutterSecureStorage();

/// Provider for the currently selected AI mode
/// Uses keepAlive to persist across screens
@Riverpod(keepAlive: true)
class SelectedMode extends _$SelectedMode {
  @override
  AIMode build() {
    _loadSavedMode();
    return DefaultAIModes.defaultMode;
  }

  Future<void> _loadSavedMode() async {
    try {
      final modeId = await _secureStorage.read(key: StorageKeys.selectedAiMode);

      if (modeId != null) {
        final mode = DefaultAIModes.fromId(modeId);
        if (mode != null) {
          state = mode;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to load saved AI mode: \$e');
      }
    }
  }

  Future<void> _saveMode() async {
    try {
      await _secureStorage.write(key: StorageKeys.selectedAiMode, value: state.id);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to save AI mode: \$e');
      }
    }
  }

  void selectMode(AIMode mode) {
    state = mode;
    _saveMode();
  }

  void selectModeById(String modeId) {
    final mode = DefaultAIModes.fromId(modeId);
    if (mode != null) {
      state = mode;
      _saveMode();
    }
  }

  void resetToDefault() {
    state = DefaultAIModes.defaultMode;
    _saveMode();
  }

  String get modeId => state.id;
}

/// Provider that returns all available AI modes
@riverpod
List<AIMode> availableModes(AvailableModesRef ref) {
  return DefaultAIModes.all;
}

/// Provider that returns the currently selected mode ID
@riverpod
String selectedModeId(SelectedModeIdRef ref) {
  final mode = ref.watch(selectedModeProvider);
  return mode.id;
}

/// Provider that returns true if the mode selector is loading
/// (always false since modes are statically defined)
@riverpod
bool isModeLoading(IsModeLoadingRef ref) {
  return false;
}
