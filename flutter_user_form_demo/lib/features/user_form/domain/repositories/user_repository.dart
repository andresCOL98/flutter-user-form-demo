import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../entities/address.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> createUser(User user);
  Future<Either<Failure, User>> getUserById(String userId);
  Future<Either<Failure, User>> updateUser(User user);
  Future<Either<Failure, void>> deleteUser(String userId);
  Future<Either<Failure, List<User>>> getAllUsers();
  Future<Either<Failure, List<User>>> searchUsersByName(String name);
  Future<Either<Failure, User>> addAddressToUser(
      String userId, Address address);
  Future<Either<Failure, User>> updateUserAddress(
      String userId, Address address);
  Future<Either<Failure, User>> removeUserAddress(
      String userId, String addressId);
  Future<Either<Failure, User>> setPrimaryAddress(
      String userId, String addressId);
}
