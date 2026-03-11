import 'package:real_estate_app/core/errors/failure.dart';

abstract class AppException {
  final String message;
  final int? statusCode;
  final dynamic data;
  final FailureType type;

  const AppException({
    required this.message,
    this.statusCode,
    this.data,
    this.type = FailureType.unknown,
  });

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.data,
    super.type = FailureType.server,
  });
}

class ClientException extends AppException {
  const ClientException({
    required super.message,
    super.statusCode,
    super.data,
    super.type = FailureType.client,
  });
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
    super.statusCode,
    super.data,
    super.type = FailureType.network,
  });
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timeout. Please try again.',
    super.statusCode,
    super.data,
    super.type = FailureType.timeout,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Unauthorized access. Please login again.',
    super.statusCode = 401,
    super.data,
    super.type = FailureType.unauthorized,
  });
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'Access forbidden. You don\'t have permission.',
    super.statusCode = 403,
    super.data,
    super.type = FailureType.forbidden,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Resource not found.',
    super.statusCode = 404,
    super.data,
    super.type = FailureType.notFound,
  });
}

class ConflictException extends AppException {
  const ConflictException({
    super.message = 'Conflict occurred. Resource already exists.',
    super.statusCode = 409,
    super.data,
    super.type = FailureType.conflict,
  });
}

class ValidationException extends AppException {
  const ValidationException({
    super.message = 'Validation failed.',
    super.statusCode = 422,
    super.data,
    super.type = FailureType.validation,
  });
}

class BadRequestException extends AppException {
  const BadRequestException({
    super.message = 'Bad request. Please check your input.',
    super.statusCode = 400,
    super.data,
    super.type = FailureType.badRequest,
  });
}

class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unexpected error occurred. Please try again.',
    super.statusCode,
    super.data,
    super.type = FailureType.unknown,
  });
}

class CancellationException extends AppException {
  const CancellationException({
    super.message = 'Request was cancelled.',
    super.statusCode,
    super.data,
    super.type = FailureType.cancelled,
  });
}
