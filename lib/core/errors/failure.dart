class Failure {
  final String message;
  final int? statusCode;
  final FailureType type;
  Failure({required this.message, this.statusCode, required this.type});
}

enum FailureType {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  validation,
  server,
  client,
  cancelled,
  conflict,
  badRequest,
  unknown,
}
