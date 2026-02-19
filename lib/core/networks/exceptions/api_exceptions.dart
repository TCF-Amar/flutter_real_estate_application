import 'package:real_estate_app/core/errors/failure.dart';
import 'exceptions.dart';

class ApiException {
  static Failure map(AppException e) {
    return Failure(
      message: e.message,
      type: _mapType(e),
      statusCode: e.statusCode,
    );
  }

  static FailureType _mapType(AppException e) {
    if (e is NetworkException) return FailureType.network;
    if (e is TimeoutException) return FailureType.timeout;
    if (e is UnauthorizedException) return FailureType.unauthorized;
    if (e is ForbiddenException) return FailureType.forbidden;
    if (e is NotFoundException) return FailureType.notFound;
    if (e is ValidationException) return FailureType.validation;
    if (e is ConflictException) return FailureType.conflict;
    if (e is BadRequestException) return FailureType.badRequest;
    if (e is CancellationException) return FailureType.cancelled;
    if (e is ServerException) return FailureType.server;
    if (e is ClientException) return FailureType.client;
    return FailureType.unknown;
  }
}

extension ApiExceptionX on AppException {
  Failure toFailure() => ApiException.map(this);
}
