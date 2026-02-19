import 'package:dartz/dartz.dart';
import 'package:real_estate_app/core/errors/failure.dart';

typedef Result<T> = Either<Failure, T>;
typedef FutureResult<T> = Future<Result<T>>;
