import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/constants.dart';
import '../core/errors/failures.dart';
import '../data/models/change_review_settings.dart';

class ApiService {
  late Dio _dio;
  String? _baseUrl;
  String? _apiKey;

  ApiService() {
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(milliseconds: AppConstants.connectionTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_apiKey != null && _apiKey!.isNotEmpty) {
            options.headers['X-API-Key'] = _apiKey;

            // HMAC request signature to prevent replay attacks.
            // Signing string: "METHOD\nPATH_WITH_QUERY\nTIMESTAMP"
            // IMPORTANT: Must use uri.query (encoded) not queryParameters (decoded)
            // to match server-side req.originalUrl exactly
            final timestamp =
                DateTime.now().millisecondsSinceEpoch.toString();
            final uri = options.uri;
            
            // Use uri.query directly - it's already URL-encoded and matches req.originalUrl
            final rawPath = uri.path + (uri.hasQuery ? '?${uri.query}' : '');
            
            final signingString =
                '${options.method.toUpperCase()}\n$rawPath\n$timestamp';
            final hmac =
                Hmac(sha256, utf8.encode(_apiKey!));
            final sig =
                hmac.convert(utf8.encode(signingString)).toString();
            options.headers['X-Timestamp'] = timestamp;
            options.headers['X-Signature'] = sig;
            
            // Debug logging for signature verification (always on for now)
            debugPrint('[SignatureDebug] uri.path: ${uri.path}');
            debugPrint('[SignatureDebug] uri.query (encoded): ${uri.query}');
            debugPrint('[SignatureDebug] rawPath: $rawPath');
            debugPrint('[SignatureDebug] Client signing string: $signingString');
            debugPrint('[SignatureDebug] Client signature: ${sig.substring(0, 16)}...');
          }
          if (kDebugMode) {
            debugPrint('Request: ${options.method} ${options.uri}');
            // Omit auth headers from debug output to avoid credential leakage
            final safeHeaders = Map<String, dynamic>.from(options.headers)
              ..remove('X-API-Key')
              ..remove('X-Signature');
            debugPrint('Headers (redacted): $safeHeaders');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint('Response: ${response.statusCode} ${response.requestOptions.uri}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            debugPrint('Error: ${e.type} ${e.message}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  void configure(String baseUrl, String apiKey) {
    _baseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    _apiKey = apiKey;
    _dio.options.baseUrl = _baseUrl!;
  }

  bool get isConfigured => _baseUrl != null && _apiKey != null;

  String? get baseUrl => _baseUrl;
  String? get apiKey => _apiKey;

  void clear() {
    _baseUrl = null;
    _apiKey = null;
    _dio.options.baseUrl = '';
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParameters}) async {
    if (kDebugMode) {
      debugPrint('[ApiService:get] GET $path, queryParameters=$queryParameters');
    }
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      if (kDebugMode) {
        debugPrint('[ApiService:get] Response for $path: status=${response.statusCode}');
        // Special logging for load conversation endpoint
        if (path.contains('/api/chat/load/')) {
          debugPrint('[ApiService:get] Load conversation response data: ${response.data}');
        } else {
          debugPrint('[ApiService:get] Response data keys: ${(response.data as Map<String, dynamic>?)?.keys?.toList()}');
        }
      }
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('[ApiService:get] DioException for $path: ${e.type}, ${e.message}');
      }
      throw _handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ApiService:get] Unexpected exception for $path: $e');
      }
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<Map<String, dynamic>> post(String path, {dynamic data}) async {
    if (kDebugMode) {
      debugPrint('[ApiService] POST $path, data=$data');
    }
    try {
      final response = await _dio.post(path, data: data);
      if (kDebugMode) {
        debugPrint('[ApiService] POST $path response: ${response.data}');
      }
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<Map<String, dynamic>> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<Map<String, dynamic>> delete(String path, {dynamic data}) async {
    try {
      final response = await _dio.delete(path, data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<bool> testConnection() async {
    try {
      final response = await _dio.get(ApiEndpoints.status);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ==========================================================================
  // Change Review Settings API
  // ==========================================================================

  /// Get current change review status from backend
  Future<ChangeReviewStatusResponse> getChangeReviewStatus() async {
    try {
      final response = await _dio.get(ApiEndpoints.changeReviewStatus);
      final data = response.data as Map<String, dynamic>;
      return ChangeReviewStatusResponse.fromJson({
        'enabled': data['enabled'] ?? true,
        'mode': data['mode'] ?? 'all',
      });
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Enable or disable change review
  Future<void> setChangeReviewEnabled(bool enabled) async {
    try {
      await _dio.post(
        ApiEndpoints.setChangeReview,
        data: {'enabled': enabled},
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Set change review mode (all or dangerous only)
  Future<void> setChangeReviewMode(ChangeReviewMode mode) async {
    try {
      final modeStr = mode == ChangeReviewMode.dangerous ? 'dangerous' : 'all';
      await _dio.post(
        '${ApiEndpoints.setChangeReview}/mode',
        data: {'mode': modeStr},
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  // ==========================================================================
  // Error Handling
  // ==========================================================================

  Failure _handleDioError(DioException e) {
    if (kDebugMode) {
      debugPrint('[ApiService] DioException: type=${e.type}, message=${e.message}');
      debugPrint('[ApiService] Response: statusCode=${e.response?.statusCode}, data=${e.response?.data}');
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timeout. Please check your internet connection.');
      case DioExceptionType.connectionError:
        return const NetworkFailure('Could not connect to server. Please check the URL.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        final message = data?['error'] ?? data?['message'] ?? e.message;

        if (kDebugMode) {
          debugPrint('[ApiService] Bad response: statusCode=$statusCode, message=$message, fullData=$data');
        }

        if (statusCode == 401) {
          return AuthenticationFailure(message ?? 'Invalid API key');
        } else if (statusCode == 429) {
          return ServerFailure(message ?? 'Rate limit exceeded. Please try again later.');
        } else if (statusCode != null && statusCode >= 500) {
          return ServerFailure(message ?? 'Server error. Please try again later.');
        }
        return ServerFailure(message ?? 'Request failed');
      case DioExceptionType.cancel:
        return const NetworkFailure('Request was cancelled');
      default:
        return NetworkFailure(e.message ?? 'Network error occurred');
    }
  }
}
