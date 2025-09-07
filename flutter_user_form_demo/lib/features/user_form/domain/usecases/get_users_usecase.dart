import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use case for getting all users from the repository.
///
/// This use case retrieves all users stored in the system.
/// It can be used to display a list of users in the UI.
class GetUsersUseCase implements UseCase<List<User>, NoParams> {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(NoParams params) async {
    return await repository.getAllUsers();
  }
}
