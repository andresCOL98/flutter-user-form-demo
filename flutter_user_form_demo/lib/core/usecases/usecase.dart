import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failures.dart';

/// Base class for all use cases in the application.
///
/// Use cases are the entry points to the business logic.
/// They orchestrate the flow of data to and from the entities,
/// and direct those entities to use their Critical Business Rules
/// to achieve the goals of the use case.
abstract class UseCase<Type, Params> {
  /// Executes the use case with the given [params].
  ///
  /// Returns an [Either] with [Failure] on the left side in case of error,
  /// or the expected [Type] on the right side in case of success.
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case that doesn't require any parameters.
abstract class NoParamsUseCase<Type> {
  /// Executes the use case without parameters.
  ///
  /// Returns an [Either] with [Failure] on the left side in case of error,
  /// or the expected [Type] on the right side in case of success.
  Future<Either<Failure, Type>> call();
}

/// Base class for use case parameters.
///
/// All parameters passed to use cases should extend this class
/// to ensure they are equatable and can be compared for testing.
abstract class UseCaseParams extends Equatable {
  const UseCaseParams();
}

/// Used when a use case doesn't require any parameters.
class NoParams extends UseCaseParams {
  const NoParams();

  @override
  List<Object?> get props => [];
}
