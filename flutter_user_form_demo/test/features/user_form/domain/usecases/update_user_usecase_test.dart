import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_user_form_demo/core/errors/failures.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/user.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/usecases/update_user_usecase.dart';

import '../../../../helpers/test_mocks.dart';

void main() {
  group('UpdateUserUseCase', () {
    late UpdateUserUseCase useCase;
    late MockUserRepository mockUserRepository;

    setUp(() {
      mockUserRepository = MockUserRepository();
      useCase = UpdateUserUseCase(mockUserRepository);
    });

    tearDown(() {
      reset(mockUserRepository);
    });

    const tUserId = 'user-123';
    final tUpdatedUser = User(
      id: tUserId,
      firstName: 'Juan Carlos',
      lastName: 'Pérez Gómez',
      email: 'juan.perez@example.com',
      phoneNumber: '+57 3001234567',
      dateOfBirth: DateTime(1990, 1, 1),
      addresses: [],
      isActive: true,
      createdAt: DateTime(2024, 1, 1),
    );

    test('should return updated user when repository update is successful',
        () async {
      when(mockUserRepository.updateUser(tUpdatedUser))
          .thenAnswer((_) async => Right(tUpdatedUser));

      final params = UpdateUserParams(user: tUpdatedUser);

      final result = await useCase(params);

      expect(result, equals(Right(tUpdatedUser)));
      verify(mockUserRepository.updateUser(tUpdatedUser));
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return ValidationFailure when user id is empty', () async {
      final tInvalidUser = User(
        id: '',
        firstName: 'Juan',
        lastName: 'Pérez',
        email: 'juan.perez@example.com',
        phoneNumber: '+57 3001234567',
        dateOfBirth: DateTime(1990, 1, 1),
        addresses: [],
        isActive: true,
        createdAt: DateTime(2024, 1, 1),
      );

      final params = UpdateUserParams(user: tInvalidUser);

      final result = await useCase(params);

      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('User ID'));
          expect(failure.code, contains('EMPTY'));
        },
        (user) => fail('Should return failure'),
      );
      verifyZeroInteractions(mockUserRepository);
    });

    test('should return NotFoundFailure when user does not exist', () async {
      const tNotFoundFailure = NotFoundFailure(
        message: 'User not found',
        code: 'USER_NOT_FOUND',
      );

      when(mockUserRepository.updateUser(tUpdatedUser))
          .thenAnswer((_) async => const Left(tNotFoundFailure));

      final params = UpdateUserParams(user: tUpdatedUser);

      final result = await useCase(params);

      expect(result, equals(const Left(tNotFoundFailure)));
      verify(mockUserRepository.updateUser(tUpdatedUser));
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return ServerFailure when repository update fails', () async {
      const tServerFailure = ServerFailure(
        message: 'Failed to update user',
        code: 'USER_UPDATE_ERROR',
      );

      when(mockUserRepository.updateUser(tUpdatedUser))
          .thenAnswer((_) async => const Left(tServerFailure));

      final params = UpdateUserParams(user: tUpdatedUser);

      final result = await useCase(params);

      expect(result, equals(const Left(tServerFailure)));
      verify(mockUserRepository.updateUser(tUpdatedUser));
      verifyNoMoreInteractions(mockUserRepository);
    });
  });
}
