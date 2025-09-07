import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserUseCase implements UseCase<User, GetUserParams> {
  final UserRepository repository;

  const GetUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(GetUserParams params) async {
    if (params.userId.isEmpty) {
      return const Left(
        ValidationFailure(
          message: 'User ID cannot be empty',
          code: 'EMPTY_USER_ID',
        ),
      );
    }

    return await repository.getUserById(params.userId);
  }
}

class GetUserParams extends UseCaseParams {
  final String userId;

  const GetUserParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
