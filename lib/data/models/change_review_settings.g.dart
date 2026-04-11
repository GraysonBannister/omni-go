// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_review_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChangeReviewSettingsImpl _$$ChangeReviewSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$ChangeReviewSettingsImpl(
      enabled: json['enabled'] as bool? ?? true,
      mode: $enumDecodeNullable(_$ChangeReviewModeEnumMap, json['mode']) ??
          ChangeReviewMode.all,
    );

Map<String, dynamic> _$$ChangeReviewSettingsImplToJson(
        _$ChangeReviewSettingsImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'mode': _$ChangeReviewModeEnumMap[instance.mode]!,
    };

const _$ChangeReviewModeEnumMap = {
  ChangeReviewMode.all: 'all',
  ChangeReviewMode.dangerous: 'dangerous',
};

_$ChangeReviewStatusResponseImpl _$$ChangeReviewStatusResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ChangeReviewStatusResponseImpl(
      enabled: json['enabled'] as bool,
      mode: $enumDecodeNullable(_$ChangeReviewModeEnumMap, json['mode']) ??
          ChangeReviewMode.all,
    );

Map<String, dynamic> _$$ChangeReviewStatusResponseImplToJson(
        _$ChangeReviewStatusResponseImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'mode': _$ChangeReviewModeEnumMap[instance.mode]!,
    };
