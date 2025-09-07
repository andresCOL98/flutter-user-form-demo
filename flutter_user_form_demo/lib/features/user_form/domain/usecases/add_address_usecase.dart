import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../entities/address.dart';
import '../repositories/user_repository.dart';
import '../repositories/location_repository.dart';

class AddAddressUseCase implements UseCase<User, AddAddressParams> {
  final UserRepository userRepository;
  final LocationRepository locationRepository;

  const AddAddressUseCase({
    required this.userRepository,
    required this.locationRepository,
  });

  @override
  Future<Either<Failure, User>> call(AddAddressParams params) async {
    if (params.userId.isEmpty) {
      return const Left(
        ValidationFailure(
          message: 'User ID cannot be empty',
          code: 'EMPTY_USER_ID',
        ),
      );
    }

    if (!params.address.isValid) {
      return const Left(
        ValidationFailure(
          message: 'Invalid address data provided',
          code: 'INVALID_ADDRESS_DATA',
        ),
      );
    }

    final hierarchyValidation =
        await locationRepository.validateLocationHierarchy(
      params.address.countryId,
      params.address.departmentId,
      params.address.municipalityId,
    );

    return hierarchyValidation.fold(
      (failure) => Left(failure),
      (isValid) async {
        if (!isValid) {
          return const Left(
            ValidationFailure(
              message: 'Invalid location hierarchy',
              code: 'INVALID_LOCATION_HIERARCHY',
            ),
          );
        }

        return await userRepository.addAddressToUser(
            params.userId, params.address);
      },
    );
  }
}

class AddAddressParams extends UseCaseParams {
  final String userId;
  final Address address;

  const AddAddressParams({
    required this.userId,
    required this.address,
  });

  @override
  List<Object> get props => [userId, address];
}
