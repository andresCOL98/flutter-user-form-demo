import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

@injectable
class CreateUserUseCase implements UseCase<User, CreateUserParams> {
  final UserRepository repository;

  const CreateUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(CreateUserParams params) async {
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

    return await repository.createUser(params.user);
  }
}

class CreateUserParams extends UseCaseParams {
  final User user;

  const CreateUserParams({required this.user});

  @override
  List<Object> get props => [user];
}
