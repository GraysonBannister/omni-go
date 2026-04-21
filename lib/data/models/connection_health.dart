/// Connection health status and metrics
class ConnectionHealth {
  final bool isConnected;
  final bool isHealthy;
  final int? latencyMs;
  final int reconnectCount;
  final DateTime? lastConnectedAt;
  final DateTime? lastDisconnectedAt;
  final String? lastError;

  const ConnectionHealth({
    this.isConnected = false,
    this.isHealthy = false,
    this.latencyMs,
    this.reconnectCount = 0,
    this.lastConnectedAt,
    this.lastDisconnectedAt,
    this.lastError,
  });

  ConnectionHealth copyWith({
    bool? isConnected,
    bool? isHealthy,
    int? latencyMs,
    int? reconnectCount,
    DateTime? lastConnectedAt,
    DateTime? lastDisconnectedAt,
    String? lastError,
  }) {
    return ConnectionHealth(
      isConnected: isConnected ?? this.isConnected,
      isHealthy: isHealthy ?? this.isHealthy,
      latencyMs: latencyMs ?? this.latencyMs,
      reconnectCount: reconnectCount ?? this.reconnectCount,
      lastConnectedAt: lastConnectedAt ?? this.lastConnectedAt,
      lastDisconnectedAt: lastDisconnectedAt ?? this.lastDisconnectedAt,
      lastError: lastError ?? this.lastError,
    );
  }

  /// Get a human-readable connection quality description
  String get qualityDescription {
    if (!isConnected) return 'Disconnected';
    if (!isHealthy) return 'Unstable';
    if (latencyMs == null) return 'Connected';
    if (latencyMs! < 100) return 'Excellent';
    if (latencyMs! < 300) return 'Good';
    if (latencyMs! < 1000) return 'Fair';
    return 'Poor';
  }

  /// Get connection quality color indicator (for UI)
  ConnectionQuality get quality {
    if (!isConnected) return ConnectionQuality.disconnected;
    if (!isHealthy) return ConnectionQuality.unstable;
    if (latencyMs == null) return ConnectionQuality.good;
    if (latencyMs! < 100) return ConnectionQuality.excellent;
    if (latencyMs! < 300) return ConnectionQuality.good;
    if (latencyMs! < 1000) return ConnectionQuality.fair;
    return ConnectionQuality.poor;
  }
}

enum ConnectionQuality {
  disconnected,
  unstable,
  poor,
  fair,
  good,
  excellent,
}

extension ConnectionQualityExtension on ConnectionQuality {
  bool get isConnected => this != ConnectionQuality.disconnected;
  bool get isHealthy => this == ConnectionQuality.good || this == ConnectionQuality.excellent;
}
