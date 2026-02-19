import 'dart:io';
import 'package:dio/dio.dart';
import 'package:real_estate_app/core/networks/exceptions/exceptions.dart';

class DioExceptions {
  static AppException map(DioException error) {
    if (error.error is SocketException) {
      return const NetworkException();
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const TimeoutException();
    }

    if (error.type == DioExceptionType.cancel) {
      return const CancellationException();
    }

    final response = error.response;
    final statusCode = response?.statusCode;
    final data = response?.data;
    final message = _extractMessage(data);

    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return BadRequestException(
            message: message,
            statusCode: statusCode,
            data: data,
          );
        case 401:
          return UnauthorizedException(message: message, data: data);
        case 403:
          return ForbiddenException(message: message, data: data);
        case 404:
          return NotFoundException(message: message, data: data);
        case 409:
          return ConflictException(message: message, data: data);
        case 422:
          return ValidationException(message: message, data: data);
        default:
          if (statusCode >= 500) {
            return ServerException(
              message: message,
              statusCode: statusCode,
              data: data,
            );
          }
          return ClientException(
            message: message,
            statusCode: statusCode,
            data: data,
          );
      }
    }

    return UnknownException(message: message);
  }

  static String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] ??
          data['error'] ??
          data['detail'] ??
          'Something went wrong';
    }
    if (data is String && data.isNotEmpty) return data;
    return 'Unexpected error occurred';
  }
}
