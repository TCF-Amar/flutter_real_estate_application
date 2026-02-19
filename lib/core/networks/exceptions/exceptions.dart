abstract class AppException {
  final String message;
  final int? statusCode;
  final dynamic data;

  const AppException({required this.message, this.statusCode, this.data});

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode, super.data});
}

class ClientException extends AppException {
  const ClientException({required super.message, super.statusCode, super.data});
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
    super.statusCode,
    super.data,
  });
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timeout. Please try again.',
    super.statusCode,
    super.data,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Unauthorized access. Please login again.',
    super.statusCode = 401,
    super.data,
  });
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'Access forbidden. You don\'t have permission.',
    super.statusCode = 403,
    super.data,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Resource not found.',
    super.statusCode = 404,
    super.data,
  });
}

class ConflictException extends AppException {
  const ConflictException({
    super.message = 'Conflict occurred. Resource already exists.',
    super.statusCode = 409,
    super.data,
  });
}

class ValidationException extends AppException {
  const ValidationException({
    super.message = 'Validation failed.',
    super.statusCode = 422,
    super.data,
  });
}

class BadRequestException extends AppException {
  const BadRequestException({
    super.message = 'Bad request. Please check your input.',
    super.statusCode = 400,
    super.data,
  });
}

class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unexpected error occurred. Please try again.',
    super.statusCode,
    super.data,
  });
}

class CancellationException extends AppException {
  const CancellationException({
    super.message = 'Request was cancelled.',
    super.statusCode,
    super.data,
  });
}
