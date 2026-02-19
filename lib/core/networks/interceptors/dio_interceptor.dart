import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/constants/api_endpoints.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/core/storage/token_storage.dart';

class DioInterceptors extends Interceptor {
  final Logger log = Logger();
  final TokenStorage _tokenStorage;
  final Dio _dio;

  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingRequests = [];

  DioInterceptors(this._tokenStorage, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.contains(ApiEndpoints.refreshToken)) {
      log.d('⟳ Refresh token request — skipping auth header');
      return handler.next(options);
    }

    final token = await _tokenStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      log.d('→ [${options.method}] ${options.path}');
    } else {
      log.w('→ [${options.method}] ${options.path} — no token');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log.i('✓ [${response.statusCode}] ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final path = err.requestOptions.path;

    log.e('✗ [$status] $path — ${err.message}');

    // Only attempt refresh on 401 Unauthorized
    if (status == 401 && !path.contains(ApiEndpoints.refreshToken)) {
      if (_isRefreshing) {
        log.d('⏳ Refresh in progress — queuing request: $path');
        _pendingRequests.add(_PendingRequest(err.requestOptions, handler));
        return;
      }

      _isRefreshing = true;
      log.i('⟳ Attempting token refresh...');

      final refreshed = await _tryRefreshToken();

      if (refreshed) {
        log.i(
          '✓ Token refreshed — retrying ${_pendingRequests.length + 1} request(s)',
        );

        try {
          final response = await _retryRequest(err.requestOptions);
          handler.resolve(response);
        } catch (e) {
          log.e('✗ Retry failed for $path: $e');
          handler.next(err);
        }

        for (final pending in _pendingRequests) {
          try {
            final response = await _retryRequest(pending.options);
            pending.handler.resolve(response);
          } catch (e) {
            log.e('✗ Retry failed for ${pending.options.path}: $e');
            pending.handler.next(err);
          }
        }
      } else {
        log.w('✗ Token refresh failed — forcing logout');
        await _forceLogout();
        handler.next(err);
        for (final pending in _pendingRequests) {
          pending.handler.next(err);
        }
      }

      _pendingRequests.clear();
      _isRefreshing = false;
      return;
    }

    if (status == 403) {
      log.w('⛔ 403 Forbidden — forcing logout');
      await _forceLogout();
    }

    handler.next(err);
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        log.w('⟳ No refresh token stored');
        return false;
      }

      log.d('⟳ POST ${ApiEndpoints.refreshToken}');
      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );

      final data = response.data;
      final newToken = data['data']?['token'] as String?;
      final newRefreshToken = data['data']?['refresh_token'] as String?;
      final expiresAt = data['data']?['expires_at'] as String?;

      if (newToken == null) {
        log.w('⟳ Refresh response missing token');
        return false;
      }

      await _tokenStorage.saveTokens(
        newToken,
        newRefreshToken ?? refreshToken,
        expiresAt: expiresAt,
      );
      log.i('✓ New token saved (expires: $expiresAt)');
      return true;
    } catch (e) {
      log.e('✗ Refresh token request failed: $e');
      return false;
    }
  }

  Future<Response> _retryRequest(RequestOptions options) async {
    final token = await _tokenStorage.getToken();
    options.headers['Authorization'] = 'Bearer $token';
    log.d('↩ Retrying [${options.method}] ${options.path}');
    return _dio.fetch(options);
  }

  Future<void> _forceLogout() async {
    log.w('🚪 Force logout — clearing tokens');
    await _tokenStorage.deleteTokens();
    Get.offAllNamed(AppRoutes.signin);
  }
}

class _PendingRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;
  _PendingRequest(this.options, this.handler);
}
