import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

@injectable
class UpdateUserUseCase implements UseCase<User, UpdateUserParams> {
  final UserRepository repository;

  const UpdateUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateUserParams params) async {
    if (!params.user.isValid) {
      return const Left(
        ValidationFailure(
          message: 'Invalid user data provided',
          code: 'INVALID_USER_DATA',
        ),
      );
    }

    if (params.user.email != null &&
        params.user.email!.isNotEmpty &&
        !params.user.hasValidEmail) {
      return const Left(
        ValidationFailure(
          message: 'Invalid email format',
          code: 'INVALID_EMAIL_FORMAT',
        ),
      );
    }

    if (params.user.age < 0) {
      return const Left(
        ValidationFailure(
          message: 'Invalid date of birth',
          code: 'INVALID_DATE_OF_BIRTH',
        ),
      );
    }

    return await repository.updateUser(params.user);
  }
}

@injectable
class GetAllUsersUseCase implements NoParamsUseCase<List<User>> {
  final UserRepository repository;

  const GetAllUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<User>>> call() async {
    final result = await repository.getAllUsers();

    return result.fold(
      (failure) => Left(failure),
      (users) {
        final activeUsers = users.where((user) => user.isActive).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return Right(activeUsers);
      },
    );
  }
}

class UpdateUserParams extends UseCaseParams {
  final User user;

  const UpdateUserParams({required this.user});

  @override
  List<Object> get props => [user];
}
