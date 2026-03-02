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

  // ── onRequest ─────────────────────────────────────────────

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
      }
      
    }
    handler.next(options);
  }


  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;

    if (status == null ||
        status != 401 ||
        err.requestOptions.path.contains(ApiEndpoints.refreshToken) ||
        err.requestOptions.extra['isRetry'] == true) {
      return handler.next(err);
    }

    if (_isRefreshing) {
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

    if (refreshed) {
      final pendingRequests = [
        (options: err.requestOptions, handler: handler),
        ..._queue,
      ];
      _queue.clear();

      for (final r in pendingRequests) {
        try {
          r.handler.resolve(await _retry(r.options));
        } catch (retryErr) {
          r.handler.next(err);
        }
      }
    } else {
      await _forceLogout();
      final pendingRequests = [..._queue];
      _queue.clear();
      for (final r in pendingRequests) {
        r.handler.next(err);
      }
      handler.next(err);
    }
  }

  
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final res = await dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
        options: Options(extra: {'skipAuth': true}),
      );

      final data = res.data?['data'];
      if (data == null) return false;

      final newToken = data['token'] as String?;
      if (newToken == null || newToken.isEmpty) return false;

      final newRefreshToken =
          (data['refresh_token'] as String?) ?? refreshToken;
      final expiresAt = data['expires_at'] as String?;

      await tokenStorage.saveTokens(
        newToken,
        newRefreshToken,
        expiresAt: expiresAt,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  
  Future<Response> _retry(RequestOptions options) async {
    final token = await tokenStorage.getToken();
    if (token == null || token.isEmpty) {
      throw DioException(
        requestOptions: options,
        message: 'No access token available after refresh.',
      );
    }
    options.headers['Authorization'] = 'Bearer $token';
    options.extra['isRetry'] = true;
    return dio.fetch(options);
  }

  
  Future<void> _forceLogout() async {
    await tokenStorage.deleteTokens();
    Get.offAllNamed(AppRoutes.signin);
  }
}
