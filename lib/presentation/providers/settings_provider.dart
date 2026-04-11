import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/change_review_settings.dart';
import '../../services/api_service.dart';

/// Provider for the API service
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

/// Provider for SharedPreferences instance (overridden at startup in main.dart)
final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) => null);

// ---------------------------------------------------------------------------
// Theme mode persistence
// ---------------------------------------------------------------------------

const _themeModeKey = 'theme_mode';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeModeNotifier(this._prefs) : super(_load(_prefs));

  static ThemeMode _load(SharedPreferences p) {
    switch (p.getString(_themeModeKey)) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(_themeModeKey, mode.name);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  // prefs is guaranteed non-null because main.dart overrides the provider
  return ThemeModeNotifier(prefs!);
});

/// State for change review settings
class ChangeReviewSettingsState {
  final bool enabled;
  final ChangeReviewMode mode;
  final bool isLoading;
  final String? error;

  const ChangeReviewSettingsState({
    this.enabled = true,
    this.mode = ChangeReviewMode.all,
    this.isLoading = false,
    this.error,
  });

  ChangeReviewSettingsState copyWith({
    bool? enabled,
    ChangeReviewMode? mode,
    bool? isLoading,
    String? error,
  }) {
    return ChangeReviewSettingsState(
      enabled: enabled ?? this.enabled,
      mode: mode ?? this.mode,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Notifier for managing change review settings
class ChangeReviewSettingsNotifier extends StateNotifier<ChangeReviewSettingsState> {
  final ApiService _apiService;
  SharedPreferences? _prefs;

  static const _prefsKey = 'change_review_settings';

  ChangeReviewSettingsNotifier(this._apiService) : super(const ChangeReviewSettingsState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    // Load from local storage first (for immediate UI)
    await _loadFromLocalStorage();
    // Then sync with backend
    await syncFromBackend();
  }

  Future<void> _loadFromLocalStorage() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final jsonStr = _prefs?.getString(_prefsKey);
      if (jsonStr != null) {
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        final settings = ChangeReviewSettings.fromJson(json);
        state = state.copyWith(
          enabled: settings.enabled,
          mode: settings.mode,
        );
      }
    } catch (e) {
      print('[ChangeReviewSettings] Error loading from local storage: $e');
    }
  }

  Future<void> _saveToLocalStorage() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      final settings = ChangeReviewSettings(
        enabled: state.enabled,
        mode: state.mode,
      );
      await _prefs?.setString(_prefsKey, jsonEncode(settings.toJson()));
    } catch (e) {
      print('[ChangeReviewSettings] Error saving to local storage: $e');
    }
  }

  /// Sync settings from backend
  Future<void> syncFromBackend() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiService.getChangeReviewStatus();
      state = state.copyWith(
        enabled: response.enabled,
        mode: response.mode,
        isLoading: false,
      );
      await _saveToLocalStorage();
    } catch (e) {
      print('[ChangeReviewSettings] Error syncing from backend: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Toggle change review enabled/disabled
  Future<void> toggleEnabled(bool enabled) async {
    state = state.copyWith(enabled: enabled, isLoading: true, error: null);
    try {
      await _apiService.setChangeReviewEnabled(enabled);
      await _saveToLocalStorage();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      print('[ChangeReviewSettings] Error setting enabled: $e');
      // Revert on error
      state = state.copyWith(enabled: !enabled, isLoading: false, error: e.toString());
    }
  }

  /// Set change review mode
  Future<void> setMode(ChangeReviewMode mode) async {
    state = state.copyWith(mode: mode, isLoading: true, error: null);
    try {
      await _apiService.setChangeReviewMode(mode);
      await _saveToLocalStorage();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      print('[ChangeReviewSettings] Error setting mode: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// Provider for change review settings
final changeReviewSettingsProvider =
    StateNotifierProvider<ChangeReviewSettingsNotifier, ChangeReviewSettingsState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ChangeReviewSettingsNotifier(apiService);
});
