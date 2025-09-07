import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_user_form_demo/core/errors/failures.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/user.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/address.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/repositories/user_repository.dart';

import '../../../../helpers/test_mocks.dart';

void main() {
  group('UserRepository Interface', () {
    late MockUserRepository mockUserRepository;

    setUp(() {
      mockUserRepository = MockUserRepository();
    });

    final tDateTime = DateTime(2024, 1, 1);
    final tBirthDate = DateTime(1990, 5, 15);

    final tUser = User(
      id: '1',
      firstName: 'Juan',
      lastName: 'Pérez',
      dateOfBirth: tBirthDate,
      createdAt: tDateTime,
    );

    final tAddress = Address(
      id: 'addr_1',
      streetAddress: 'Calle 123 #45-67',
      city: 'Medellín',
      postalCode: '050001',
      countryId: 'CO',
      departmentId: 'ANT',
      municipalityId: 'MED',
      createdAt: tDateTime,
    );

    final tUsers = [tUser];

    group('createUser', () {
      test('should define createUser method signature', () {
        when(mockUserRepository.createUser(tUser))
            .thenAnswer((_) async => Right(tUser));

        expect(mockUserRepository.createUser, isA<Function>());
      });

      test('should return User on successful creation', () async {
        when(mockUserRepository.createUser(tUser))
            .thenAnswer((_) async => Right(tUser));

        final result = await mockUserRepository.createUser(tUser);

        expect(result, isA<Right<Failure, User>>());
        result.fold(
          (failure) => fail('Should return success'),
          (user) => expect(user, equals(tUser)),
        );
        verify(mockUserRepository.createUser(tUser));
      });

      test('should return Failure on creation error', () async {
        const tFailure = ServerFailure(
          message: 'Failed to create user',
          code: 'CREATE_ERROR',
        );

        when(mockUserRepository.createUser(tUser))
            .thenAnswer((_) async => const Left(tFailure));

        final result = await mockUserRepository.createUser(tUser);

        expect(result, isA<Left<Failure, User>>());
        expect(result, equals(const Left(tFailure)));
        verify(mockUserRepository.createUser(tUser));
      });
    });

    group('getUserById', () {
      test('should define getUserById method signature', () {
        when(mockUserRepository.getUserById('1'))
            .thenAnswer((_) async => Right(tUser));

        expect(mockUserRepository.getUserById, isA<Function>());
      });

      test('should return User when user exists', () async {
        when(mockUserRepository.getUserById('1'))
            .thenAnswer((_) async => Right(tUser));

        final result = await mockUserRepository.getUserById('1');

        expect(result, isA<Right<Failure, User>>());
        result.fold(
          (failure) => fail('Should return success'),
          (user) => expect(user, equals(tUser)),
        );
        verify(mockUserRepository.getUserById('1'));
      });

      test('should return NotFoundFailure when user does not exist', () async {
        const tFailure = NotFoundFailure(
          message: 'User not found',
          code: 'USER_NOT_FOUND',
        );

        when(mockUserRepository.getUserById('999'))
            .thenAnswer((_) async => const Left(tFailure));

        final result = await mockUserRepository.getUserById('999');

        expect(result, isA<Left<Failure, User>>());
        expect(result, equals(const Left(tFailure)));
        verify(mockUserRepository.getUserById('999'));
      });
    });

    group('updateUser', () {
      test('should define updateUser method signature', () {
        // arrange & act
        when(mockUserRepository.updateUser(tUser))
            .thenAnswer((_) async => Right(tUser));

        // assert - method signature exists and can be mocked
        expect(mockUserRepository.updateUser, isA<Function>());
      });

      test('should return updated User on success', () async {
        // arrange
        final updatedUser = User(
          id: '1',
          firstName: 'Juan Carlos',
          lastName: 'Pérez García',
          dateOfBirth: tBirthDate,
          createdAt: tDateTime,
          updatedAt: tDateTime,
        );

        when(mockUserRepository.updateUser(updatedUser))
            .thenAnswer((_) async => Right(updatedUser));

        // act
        final result = await mockUserRepository.updateUser(updatedUser);

        // assert
        expect(result, isA<Right<Failure, User>>());
        result.fold(
          (failure) => fail('Should return success'),
          (user) => expect(user, equals(updatedUser)),
        );
        verify(mockUserRepository.updateUser(updatedUser));
      });

      test('should return Failure when update fails', () async {
        // arrange
        const tFailure = ServerFailure(
          message: 'Failed to update user',
          code: 'UPDATE_ERROR',
        );

        when(mockUserRepository.updateUser(tUser))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await mockUserRepository.updateUser(tUser);

        // assert
        expect(result, isA<Left<Failure, User>>());
        expect(result, equals(const Left(tFailure)));
        verify(mockUserRepository.updateUser(tUser));
      });
    });

    group('deleteUser', () {
      test('should define deleteUser method signature', () {
        // arrange & act
        when(mockUserRepository.deleteUser('1'))
            .thenAnswer((_) async => const Right(null));

        // assert - method signature exists and can be mocked
        expect(mockUserRepository.deleteUser, isA<Function>());
      });

      test('should return void on successful deletion', () async {
        // arrange
        when(mockUserRepository.deleteUser('1'))
            .thenAnswer((_) async => const Right(null));

        // act
        final result = await mockUserRepository.deleteUser('1');

        // assert
        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Should return success'),
          (success) => {}, // void type, no assertion needed
        );
        verify(mockUserRepository.deleteUser('1'));
      });

      test('should return Failure when deletion fails', () async {
        // arrange
        const tFailure = NotFoundFailure(
          message: 'User not found',
          code: 'USER_NOT_FOUND',
        );

        when(mockUserRepository.deleteUser('999'))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await mockUserRepository.deleteUser('999');

        // assert
        expect(result, isA<Left<Failure, void>>());
        expect(result, equals(const Left(tFailure)));
        verify(mockUserRepository.deleteUser('999'));
      });
    });

    group('getAllUsers', () {
      test('should define getAllUsers method signature', () {
        // arrange & act
        when(mockUserRepository.getAllUsers())
            .thenAnswer((_) async => Right(tUsers));

        // assert - method signature exists and can be mocked
        expect(mockUserRepository.getAllUsers, isA<Function>());
      });

      test('should return list of Users on success', () async {
        // arrange
        when(mockUserRepository.getAllUsers())
            .thenAnswer((_) async => Right(tUsers));

        // act
        final result = await mockUserRepository.getAllUsers();

        // assert
        expect(result, isA<Right<Failure, List<User>>>());
        result.fold(
          (failure) => fail('Should return success'),
          (users) => expect(users, equals(tUsers)),
        );
        verify(mockUserRepository.getAllUsers());
      });

      test('should return empty list when no users exist', () async {
        // arrange
        when(mockUserRepository.getAllUsers())
            .thenAnswer((_) async => const Right([]));

        // act
        final result = await mockUserRepository.getAllUsers();

        // assert
        expect(result, isA<Right<Failure, List<User>>>());
        result.fold(
          (failure) => fail('Should return success'),
          (users) => expect(users, isEmpty),
        );
        verify(mockUserRepository.getAllUsers());
      });

      test('should return Failure on error', () async {
        // arrange
        const tFailure = ServerFailure(
          message: 'Failed to load users',
          code: 'LOAD_ERROR',
        );

        when(mockUserRepository.getAllUsers())
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await mockUserRepository.getAllUsers();

        // assert
        expect(result, isA<Left<Failure, List<User>>>());
        expect(result, equals(const Left(tFailure)));
        verify(mockUserRepository.getAllUsers());
      });
    });

    group('addAddressToUser', () {
      test('should define addAddressToUser method signature', () {
        // arrange
        final userWithAddress = tUser.addAddress(tAddress);

        when(mockUserRepository.addAddressToUser('1', tAddress))
            .thenAnswer((_) async => Right(userWithAddress));

        // assert - method signature exists and can be mocked
        expect(mockUserRepository.addAddressToUser, isA<Function>());
      });

      test('should return User with added address on success', () async {
        // arrange
        final userWithAddress = tUser.addAddress(tAddress);

        when(mockUserRepository.addAddressToUser('1', tAddress))
            .thenAnswer((_) async => Right(userWithAddress));

        // act
        final result = await mockUserRepository.addAddressToUser('1', tAddress);

        // assert
        expect(result, isA<Right<Failure, User>>());
        result.fold(
          (failure) => fail('Should return success'),
          (user) {
            expect(user.addresses.length, equals(1));
            expect(user.addresses.first, equals(tAddress));
          },
        );
        verify(mockUserRepository.addAddressToUser('1', tAddress));
      });

      test('should return Failure when user not found', () async {
        // arrange
        const tFailure = NotFoundFailure(
          message: 'User not found',
          code: 'USER_NOT_FOUND',
        );

        when(mockUserRepository.addAddressToUser('999', tAddress))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result =
            await mockUserRepository.addAddressToUser('999', tAddress);

        // assert
        expect(result, isA<Left<Failure, User>>());
        expect(result, equals(const Left(tFailure)));
        verify(mockUserRepository.addAddressToUser('999', tAddress));
      });
    });

    group('removeUserAddress', () {
      test('should define removeUserAddress method signature', () {
        // arrange & act
        when(mockUserRepository.removeUserAddress('1', 'addr_1'))
            .thenAnswer((_) async => Right(tUser));

        // assert - method signature exists and can be mocked
        expect(mockUserRepository.removeUserAddress, isA<Function>());
      });

      test('should return User without address on success', () async {
        // arrange
        when(mockUserRepository.removeUserAddress('1', 'addr_1'))
            .thenAnswer((_) async => Right(tUser));

        // act
        final result =
            await mockUserRepository.removeUserAddress('1', 'addr_1');

        // assert
        expect(result, isA<Right<Failure, User>>());
        result.fold(
          (failure) => fail('Should return success'),
          (user) => expect(user.addresses, isEmpty),
        );
        verify(mockUserRepository.removeUserAddress('1', 'addr_1'));
      });

      test('should return Failure when address removal fails', () async {
        // arrange
        const tFailure = NotFoundFailure(
          message: 'Address not found',
          code: 'ADDRESS_NOT_FOUND',
        );

        when(mockUserRepository.removeUserAddress('1', 'invalid_addr'))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result =
            await mockUserRepository.removeUserAddress('1', 'invalid_addr');

        // assert
        expect(result, isA<Left<Failure, User>>());
        expect(result, equals(const Left(tFailure)));
        verify(mockUserRepository.removeUserAddress('1', 'invalid_addr'));
      });
    });

    group('searchUsersByName', () {
      test('should define searchUsersByName method signature', () {
        // arrange & act
        when(mockUserRepository.searchUsersByName('Juan'))
            .thenAnswer((_) async => Right(tUsers));

        // assert - method signature exists and can be mocked
        expect(mockUserRepository.searchUsersByName, isA<Function>());
      });

      test('should return matching users on success', () async {
        // arrange
        when(mockUserRepository.searchUsersByName('Juan'))
            .thenAnswer((_) async => Right(tUsers));

        // act
        final result = await mockUserRepository.searchUsersByName('Juan');

        // assert
        expect(result, isA<Right<Failure, List<User>>>());
        result.fold(
          (failure) => fail('Should return success'),
          (users) => expect(users, equals(tUsers)),
        );
        verify(mockUserRepository.searchUsersByName('Juan'));
      });

      test('should return empty list when no users match', () async {
        // arrange
        when(mockUserRepository.searchUsersByName('NonExistent'))
            .thenAnswer((_) async => const Right([]));

        // act
        final result =
            await mockUserRepository.searchUsersByName('NonExistent');

        // assert
        expect(result, isA<Right<Failure, List<User>>>());
        result.fold(
          (failure) => fail('Should return success'),
          (users) => expect(users, isEmpty),
        );
        verify(mockUserRepository.searchUsersByName('NonExistent'));
      });
    });

    group('updateUserAddress', () {
      test('should define updateUserAddress method signature', () {
        // arrange
        final userWithUpdatedAddress = tUser.addAddress(tAddress);

        when(mockUserRepository.updateUserAddress('1', tAddress))
            .thenAnswer((_) async => Right(userWithUpdatedAddress));

        // assert - method signature exists and can be mocked
        expect(mockUserRepository.updateUserAddress, isA<Function>());
      });

      test('should return User with updated address on success', () async {
        // arrange
        final userWithUpdatedAddress = tUser.addAddress(tAddress);

        when(mockUserRepository.updateUserAddress('1', tAddress))
            .thenAnswer((_) async => Right(userWithUpdatedAddress));

        // act
        final result =
            await mockUserRepository.updateUserAddress('1', tAddress);

        // assert
        expect(result, isA<Right<Failure, User>>());
        result.fold(
          (failure) => fail('Should return success'),
          (user) {
            expect(user.addresses.length, equals(1));
            expect(user.addresses.first, equals(tAddress));
          },
        );
        verify(mockUserRepository.updateUserAddress('1', tAddress));
      });
    });

    group('setPrimaryAddress', () {
      test('should define setPrimaryAddress method signature', () {
        // arrange & act
        when(mockUserRepository.setPrimaryAddress('1', 'addr_1'))
            .thenAnswer((_) async => Right(tUser));

        // assert - method signature exists and can be mocked
        expect(mockUserRepository.setPrimaryAddress, isA<Function>());
      });

      test('should return User with primary address set on success', () async {
        // arrange
        when(mockUserRepository.setPrimaryAddress('1', 'addr_1'))
            .thenAnswer((_) async => Right(tUser));

        // act
        final result =
            await mockUserRepository.setPrimaryAddress('1', 'addr_1');

        // assert
        expect(result, isA<Right<Failure, User>>());
        result.fold(
          (failure) => fail('Should return success'),
          (user) => expect(user, equals(tUser)),
        );
        verify(mockUserRepository.setPrimaryAddress('1', 'addr_1'));
      });

      test('should return Failure when address not found', () async {
        // arrange
        const tFailure = NotFoundFailure(
          message: 'Address not found',
          code: 'ADDRESS_NOT_FOUND',
        );

        when(mockUserRepository.setPrimaryAddress('1', 'invalid_addr'))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result =
            await mockUserRepository.setPrimaryAddress('1', 'invalid_addr');

        // assert
        expect(result, isA<Left<Failure, User>>());
        expect(result, equals(const Left(tFailure)));
        verify(mockUserRepository.setPrimaryAddress('1', 'invalid_addr'));
      });
    });

    group('UserRepository contract validation', () {
      test('should implement all required methods', () {
        // This test ensures all methods are properly defined in the interface
        expect(mockUserRepository, isA<UserRepository>());

        // Verify method signatures exist
        expect(mockUserRepository.createUser, isA<Function>());
        expect(mockUserRepository.getUserById, isA<Function>());
        expect(mockUserRepository.updateUser, isA<Function>());
        expect(mockUserRepository.deleteUser, isA<Function>());
        expect(mockUserRepository.getAllUsers, isA<Function>());
        expect(mockUserRepository.searchUsersByName, isA<Function>());
        expect(mockUserRepository.addAddressToUser, isA<Function>());
        expect(mockUserRepository.updateUserAddress, isA<Function>());
        expect(mockUserRepository.removeUserAddress, isA<Function>());
        expect(mockUserRepository.setPrimaryAddress, isA<Function>());

        // If we get here without compilation errors, all methods are properly defined
        expect(true, isTrue);
      });
    });
  });
}
