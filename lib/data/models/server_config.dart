import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_config.freezed.dart';
part 'server_config.g.dart';

@freezed
class ServerConfig with _$ServerConfig {
  const factory ServerConfig({
    @Default('') String url,
    @Default('') String apiKey,
    @Default(false) bool isConnected,
    @Default(false) bool isLoading,
    String? error,
  }) = _ServerConfig;

  factory ServerConfig.fromJson(Map<String, dynamic> json) =>
      _$ServerConfigFromJson(json);

  factory ServerConfig.empty() => const ServerConfig();
}
