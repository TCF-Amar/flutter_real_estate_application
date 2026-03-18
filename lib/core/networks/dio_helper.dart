import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/networks/dio_client.dart';
import 'package:real_estate_app/core/networks/exceptions/dio_exceptions.dart';
import 'package:real_estate_app/core/networks/exceptions/exceptions.dart';

// ── API Method Enum ──────────────────────────────────────────

enum ApiMethod { get, post, put, delete, patch }

// ── API Request Model ────────────────────────────────────────

class ApiRequest {
  final String url;
  final ApiMethod method;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? queryParameters;
  final dynamic body;
  final String? contentType;

  ApiRequest({
    required this.url,
    required this.method,
    this.headers,
    this.queryParameters,
    this.body,
    this.contentType,
  });
}

// ── Dio Helper ───────────────────────────────────────────────

class DioHelper {
  final Logger log = Logger();
  final DioClient dioClient;

  DioHelper(this.dioClient);

  Future<Response<T>> request<T>(ApiRequest request) async {
    final method = request.method.name.toUpperCase();
    log.i('→ $method ${request.url}');

    if (request.queryParameters != null &&
        request.queryParameters!.isNotEmpty) {
      final query = request.queryParameters!.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      log.d('  Query: ?$query');
    }
    if (request.body != null && request.body is! FormData) {
      log.d('  Body: ${request.body}');
    }

    try {
      final options = Options(
        headers: request.headers,
        method: method,
        responseType: ResponseType.json,
        contentType: request.body is FormData
            ? 'multipart/form-data'
            : request.contentType ?? 'application/json',
      );

      final response = await dioClient.dio.request<T>(
        request.url,
        options: options,
        queryParameters: request.queryParameters,
        data: request.body,
      );

      log.i('← ${response.statusCode} $method ${request.url}');
      return response;
    } on DioException catch (e) {
      log.e('✖ $method ${request.url} — DioException: ${e.message}');
      throw DioExceptions.map(e);
    } catch (e) {
      log.e('✖ $method ${request.url} — Unexpected: $e');
      throw UnknownException(message: 'Unexpected error: $e');
    }
  }
}
