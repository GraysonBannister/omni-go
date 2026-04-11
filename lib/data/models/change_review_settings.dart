import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_review_settings.freezed.dart';
part 'change_review_settings.g.dart';

enum ChangeReviewMode {
  all,
  dangerous,
}

/// Settings for change review feature
@freezed
class ChangeReviewSettings with _$ChangeReviewSettings {
  const factory ChangeReviewSettings({
    @Default(true) bool enabled,
    @Default(ChangeReviewMode.all) ChangeReviewMode mode,
  }) = _ChangeReviewSettings;

  factory ChangeReviewSettings.fromJson(Map<String, dynamic> json) =>
      _$ChangeReviewSettingsFromJson(json);
}

/// Response from backend for change review status
@freezed
class ChangeReviewStatusResponse with _$ChangeReviewStatusResponse {
  const factory ChangeReviewStatusResponse({
    required bool enabled,
    @Default(ChangeReviewMode.all) ChangeReviewMode mode,
  }) = _ChangeReviewStatusResponse;

  factory ChangeReviewStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$ChangeReviewStatusResponseFromJson(json);
}
