import 'package:equatable/equatable.dart';

/// Base class for failures in the application.
///
/// All failures should extend this class to ensure
/// consistent error handling throughout the app.
abstract class Failure extends Equatable {
  /// The error message associated with the failure.
  final String message;

  /// Optional error code for categorizing failures.
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Failure related to server communication.
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });
}

/// Failure related to network connectivity.
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
  });
}

/// Failure related to caching operations.
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });
}

/// Failure related to data validation.
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

/// Failure when a resource is not found.
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.code,
  });
}

/// Failure due to insufficient permissions.
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
  });
}

/// Generic failure for unexpected errors.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required super.message,
    super.code,
  });
}
