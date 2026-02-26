import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:real_estate_app/core/constants/api_endpoints.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/core/storage/token_storage.dart';

class DioInterceptors extends Interceptor {
  final Dio dio;
  final TokenStorage tokenStorage;

  bool _isRefreshing = false;
  final List<({RequestOptions options, ErrorInterceptorHandler handler})>
  _queue = [];

  DioInterceptors({required this.dio, required this.tokenStorage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.path.contains(ApiEndpoints.refreshToken)) {
      final token = await tokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;

    // Not a 401 or already a retry → pass through
    if (status != 401 ||
        err.requestOptions.path.contains(ApiEndpoints.refreshToken) ||
        err.requestOptions.extra['isRetry'] == true) {
      return handler.next(err);
    }

    // Queue while a refresh is in progress
    if (_isRefreshing) {
      _queue.add((options: err.requestOptions, handler: handler));
      return;
    }

    _isRefreshing = true;
    final refreshed = await _refreshToken();

    if (refreshed) {
      // Retry original + queued requests
      final all = [(options: err.requestOptions, handler: handler), ..._queue];
      for (final r in all) {
        try {
          r.handler.resolve(await _retry(r.options));
        } catch (_) {
          r.handler.next(err);
        }
      }
    } else {
      await _forceLogout();
      for (final r in _queue) {
        r.handler.next(err);
      }
      handler.next(err);
    }

    _queue.clear();
    _isRefreshing = false;
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final res = await dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );
      final data = res.data['data'];
      final newToken = data['token'];
      if (newToken == null) return false;

      await tokenStorage.saveTokens(
        newToken,
        data['refresh_token'] ?? refreshToken,
        expiresAt: data['expires_at'],
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Response> _retry(RequestOptions options) async {
    final token = await tokenStorage.getToken();
    options.headers['Authorization'] = 'Bearer $token';
    options.extra['isRetry'] = true;
    return dio.fetch(options);
  }

  Future<void> _forceLogout() async {
    await tokenStorage.deleteTokens();
    Get.offAllNamed(AppRoutes.signin);
  }
}
