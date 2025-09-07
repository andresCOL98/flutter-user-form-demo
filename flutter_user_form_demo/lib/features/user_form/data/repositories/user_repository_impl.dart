import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/address.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local/user_local_data_source.dart';
import '../datasources/local/address_local_data_source.dart';
import '../models/user_model.dart';
import '../models/address_model.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource userLocalDataSource;
  final AddressLocalDataSource addressLocalDataSource;

  UserRepositoryImpl({
    required this.userLocalDataSource,
    required this.addressLocalDataSource,
  });

  @override
  Future<Either<Failure, User>> createUser(User user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      final createdUser = await userLocalDataSource.createUser(userModel);
      return Right(createdUser.toEntity());
    } catch (e) {
      return Left(
          CacheFailure(message: 'Failed to create user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> getUserById(String userId) async {
    try {
      final userModel = await userLocalDataSource.getUserById(userId);
      if (userModel != null) {
        return Right(userModel.toEntity());
      } else {
        return Left(CacheFailure(message: 'User with ID $userId not found'));
      }
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(User user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      final updatedUser = await userLocalDataSource.updateUser(userModel);
      return Right(updatedUser.toEntity());
    } catch (e) {
      return Left(
          CacheFailure(message: 'Failed to update user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String userId) async {
    try {
      await userLocalDataSource.deleteUser(userId);
      return const Right(null);
    } catch (e) {
      return Left(
          CacheFailure(message: 'Failed to delete user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    try {
      final userModels = await userLocalDataSource.getAllUsers();
      final users = userModels.map((model) => model.toEntity()).toList();
      return Right(users);
    } catch (e) {
      return Left(
          CacheFailure(message: 'Failed to get all users: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<User>>> searchUsersByName(String name) async {
    try {
      final userModels = await userLocalDataSource.searchUsersByName(name);
      final users = userModels.map((model) => model.toEntity()).toList();
      return Right(users);
    } catch (e) {
      return Left(
          CacheFailure(message: 'Failed to search users: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> addAddressToUser(
      String userId, Address address) async {
    try {
      // First, get the user to validate it exists
      final userResult = await getUserById(userId);
      if (userResult.isLeft()) {
        return userResult;
      }

      // Create the address with the userId
      final addressModel = AddressModel.fromEntity(
        address.copyWith(userId: userId),
      );
      await addressLocalDataSource.createAddress(addressModel);

      // Return the updated user (refresh from database)
      return await getUserById(userId);
    } catch (e) {
      return Left(CacheFailure(
          message: 'Failed to add address to user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserAddress(
      String userId, Address address) async {
    try {
      // Validate user exists
      final userResult = await getUserById(userId);
      if (userResult.isLeft()) {
        return userResult;
      }

      // Update the address
      final addressModel = AddressModel.fromEntity(address);
      await addressLocalDataSource.updateAddress(addressModel);

      // Return the updated user
      return await getUserById(userId);
    } catch (e) {
      return Left(CacheFailure(
          message: 'Failed to update user address: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> removeUserAddress(
      String userId, String addressId) async {
    try {
      // Validate user exists
      final userResult = await getUserById(userId);
      if (userResult.isLeft()) {
        return userResult;
      }

      // Delete the address
      await addressLocalDataSource.deleteAddress(addressId);

      // Return the updated user
      return await getUserById(userId);
    } catch (e) {
      return Left(CacheFailure(
          message: 'Failed to remove user address: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> setPrimaryAddress(
      String userId, String addressId) async {
    try {
      // Validate user exists
      final userResult = await getUserById(userId);
      if (userResult.isLeft()) {
        return userResult;
      }

      // Set the primary address
      await addressLocalDataSource.setPrimaryAddress(userId, addressId);

      // Return the updated user
      return await getUserById(userId);
    } catch (e) {
      return Left(CacheFailure(
          message: 'Failed to set primary address: ${e.toString()}'));
    }
  }
}
