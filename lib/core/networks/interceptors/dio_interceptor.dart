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
  final List<_PendingRequest> _queue = [];

  DioInterceptors({required this.dio, required this.tokenStorage});

  // ==========================
  // REQUEST
  // ==========================
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.contains(ApiEndpoints.refreshToken)) {
      return handler.next(options);
    }

    final token = await tokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  // ==========================
  // RESPONSE
  // ==========================
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  // ==========================
  // ERROR
  // ==========================
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final requestOptions = err.requestOptions;

    // 1️⃣ Handle No Internet
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.unknown) {
      log.w('No Internet Connection');
      return handler.next(err);
    }

    // 2️⃣ Handle 401 Unauthorized
    if (status == 401 &&
        !requestOptions.path.contains(ApiEndpoints.refreshToken)) {
      // Prevent infinite retry loop
      if (requestOptions.extra['isRetry'] == true) {
        await _forceLogout();
        return handler.next(err);
      }

      // If already refreshing → queue request
      if (_isRefreshing) {
        _queue.add(_PendingRequest(requestOptions, handler));
        return;
      }

      _isRefreshing = true;

      final refreshed = await _refreshToken();

      if (refreshed) {
        // Retry original request
        try {
          final response = await _retry(
            requestOptions..extra['isRetry'] = true,
          );
          handler.resolve(response);
        } catch (e) {
          handler.next(err);
        }

        // Retry queued requests
        for (final pending in _queue) {
          try {
            final response = await _retry(
              pending.options..extra['isRetry'] = true,
            );
            pending.handler.resolve(response);
          } catch (e) {
            pending.handler.next(err);
          }
        }
      } else {
        await _forceLogout();
        handler.next(err);
        for (final pending in _queue) {
          pending.handler.next(err);
        }
      }

      _queue.clear();
      _isRefreshing = false;
      return;
    }

    // 3️⃣ Optional: Handle 403 (No logout)
    if (status == 403) {
      log.w('Access forbidden — no logout');
      return handler.next(err);
    }

    handler.next(err);
  }

  // ==========================
  // REFRESH TOKEN
  // ==========================
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );

      final data = response.data['data'];
      final newToken = data['token'];
      final newRefreshToken = data['refresh_token'];
      final expiresAt = data['expires_at'];

      if (newToken == null) return false;

      await tokenStorage.saveTokens(
        newToken,
        newRefreshToken ?? refreshToken,
        expiresAt: expiresAt,
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  // ==========================
  // RETRY REQUEST
  // ==========================
  Future<Response> _retry(RequestOptions options) async {
    final token = await tokenStorage.getToken();
    options.headers['Authorization'] = 'Bearer $token';
    return dio.fetch(options);
  }

  // ==========================
  // FORCE LOGOUT
  // ==========================
  Future<void> _forceLogout() async {
    await tokenStorage.deleteTokens();
    Get.offAllNamed(AppRoutes.signin);
  }
}

// ==========================
// QUEUE MODEL
// ==========================
class _PendingRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  _PendingRequest(this.options, this.handler);
}
