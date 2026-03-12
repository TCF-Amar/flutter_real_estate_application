import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/constants/api_endpoints.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/core/storage/token_storage.dart';

class DioInterceptors extends Interceptor {
  final Dio dio;
  final TokenStorage tokenStorage;
  final Logger log = Logger();

  bool _isRefreshing = false;

  final List<({RequestOptions options, ErrorInterceptorHandler handler})>
      _queue = [];

  DioInterceptors({required this.dio, required this.tokenStorage});

  // ── onRequest — Attach Auth Token ─────────────────────────

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isRefreshCall = options.path.contains(ApiEndpoints.refreshToken);
    final skipAuth = options.extra['skipAuth'] == true;

    if (!isRefreshCall && !skipAuth) {
      final token = await tokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        log.d('🔑 Token attached to: ${options.method} ${options.path}');
      } else {
        log.w('⚠ No token available for: ${options.method} ${options.path}');
      }
    }

    handler.next(options);
  }

  // ── onError — Handle 401 & Token Refresh ──────────────────

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final path = err.requestOptions.path;

    // Pass through non-401 errors, refresh calls, and retried requests
    if (status == null ||
        status != 401 ||
        path.contains(ApiEndpoints.refreshToken) ||
        err.requestOptions.extra['isRetry'] == true) {
      log.e('✖ [$status] ${err.requestOptions.method} $path — ${err.message}');
      return handler.next(err);
    }

    log.w('🔄 401 received for $path — attempting token refresh...');

    // Queue concurrent requests while refreshing
    if (_isRefreshing) {
      log.d('  Queuing request: $path (refresh in progress)');
      _queue.add((options: err.requestOptions, handler: handler));
      return;
    }

    _isRefreshing = true;
    bool refreshed = false;

    try {
      refreshed = await _refreshToken();
    } finally {
      _isRefreshing = false;
    }

    // ── Retry or Force Logout ─────────────────────────────

    if (refreshed) {
      log.i('✅ Token refreshed — retrying ${_queue.length + 1} request(s)');
      final pendingRequests = [
        (options: err.requestOptions, handler: handler),
        ..._queue,
      ];
      _queue.clear();

      for (final r in pendingRequests) {
        try {
          r.handler.resolve(await _retry(r.options));
        } catch (retryErr) {
          log.e('✖ Retry failed for ${r.options.path}: $retryErr');
          r.handler.next(err);
        }
      }
    } else {
      log.e('❌ Token refresh failed — forcing logout');
      await _forceLogout();
      final pendingRequests = [..._queue];
      _queue.clear();
      for (final r in pendingRequests) {
        r.handler.next(err);
      }
      handler.next(err);
    }
  }

  // ── Token Refresh ─────────────────────────────────────────

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        log.w('No refresh token available');
        return false;
      }

      log.d('Sending refresh token request...');
      final res = await dio.post(
        ApiEndpoints.refreshToken,
        options: Options(
          headers: {'Authorization': 'Bearer $refreshToken'},
          extra: {'skipAuth': true},
        ),
      );

      final data = res.data?['data'];
      if (data == null) {
        log.w('Refresh response missing data');
        return false;
      }

      final newToken = data['token'] as String?;
      if (newToken == null || newToken.isEmpty) {
        log.w('Refresh response missing token');
        return false;
      }

      final newRefreshToken =
          (data['refresh_token'] as String?) ?? refreshToken;
      final expiresAt = data['expires_at'] as String?;

      await tokenStorage.saveTokens(
        newToken,
        newRefreshToken,
        expiresAt: expiresAt,
      );

      log.i('Token refreshed successfully (expires: $expiresAt)');
      return true;
    } catch (e) {
      log.e('Token refresh threw: $e');
      return false;
    }
  }

  // ── Retry Request ─────────────────────────────────────────

  Future<Response> _retry(RequestOptions options) async {
    final token = await tokenStorage.getToken();
    if (token == null || token.isEmpty) {
      log.e('No access token available for retry: ${options.path}');
      throw DioException(
        requestOptions: options,
        message: 'No access token available after refresh.',
      );
    }

    log.d('🔄 Retrying: ${options.method} ${options.path}');
    options.headers['Authorization'] = 'Bearer $token';
    options.extra['isRetry'] = true;
    return dio.fetch(options);
  }

  // ── Force Logout ──────────────────────────────────────────

  Future<void> _forceLogout() async {
    log.w('Force logout — clearing tokens and redirecting to sign-in');
    await tokenStorage.deleteTokens();
    Get.offAllNamed(AppRoutes.signin);
  }
}
