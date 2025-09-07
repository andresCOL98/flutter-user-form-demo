import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_user_form_demo/core/errors/failures.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/user.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/usecases/create_user_usecase.dart';

import '../../../../helpers/test_mocks.dart';

void main() {
  late CreateUserUseCase useCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    useCase = CreateUserUseCase(mockUserRepository);
  });

  group('CreateUserUseCase', () {
    final tDateTime = DateTime(2024, 1, 1);
    final tBirthDate = DateTime(1990, 5, 15);

    final tUser = User(
      id: '1',
      firstName: 'Juan',
      lastName: 'Pérez',
      dateOfBirth: tBirthDate,
      email: 'juan.perez@email.com',
      phoneNumber: '+57 300 1234567',
      createdAt: tDateTime,
    );

    final tParams = CreateUserParams(user: tUser);

    test('should create user successfully when data is valid', () async {
      when(mockUserRepository.createUser(tUser))
          .thenAnswer((_) async => Right(tUser));

      final result = await useCase(tParams);

      expect(result, equals(Right(tUser)));
      verify(mockUserRepository.createUser(tUser));
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return ValidationFailure when user data is invalid', () async {
      final invalidUser = User(
        id: '1',
        firstName: '',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        createdAt: tDateTime,
      );
      final invalidParams = CreateUserParams(user: invalidUser);

      final result = await useCase(invalidParams);

      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, equals('Invalid user data provided'));
          expect(failure.code, equals('INVALID_USER_DATA'));
        },
        (user) => fail('Should return failure'),
      );
      verifyZeroInteractions(mockUserRepository);
    });

    test('should return ValidationFailure when email format is invalid',
        () async {
      final userWithInvalidEmail = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        email: 'invalid-email',
        createdAt: tDateTime,
      );
      final invalidParams = CreateUserParams(user: userWithInvalidEmail);

      final result = await useCase(invalidParams);

      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, equals('Invalid email format'));
          expect(failure.code, equals('INVALID_EMAIL_FORMAT'));
        },
        (user) => fail('Should return failure'),
      );
      verifyZeroInteractions(mockUserRepository);
    });

    test('should return ValidationFailure when date of birth is in the future',
        () async {
      final futureDate = DateTime.now().add(const Duration(days: 365));
      final userWithFutureBirthDate = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: futureDate,
        createdAt: tDateTime,
      );
      final invalidParams = CreateUserParams(user: userWithFutureBirthDate);

      final result = await useCase(invalidParams);

      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, equals('Invalid date of birth'));
          expect(failure.code, equals('INVALID_DATE_OF_BIRTH'));
        },
        (user) => fail('Should return failure'),
      );
      verifyZeroInteractions(mockUserRepository);
    });

    test('should create user successfully when email is null', () async {
      final userWithNullEmail = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        email: null,
        createdAt: tDateTime,
      );
      final params = CreateUserParams(user: userWithNullEmail);

      when(mockUserRepository.createUser(userWithNullEmail))
          .thenAnswer((_) async => Right(userWithNullEmail));

      final result = await useCase(params);

      expect(result, equals(Right(userWithNullEmail)));
      verify(mockUserRepository.createUser(userWithNullEmail));
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should create user successfully when email is empty', () async {
      final userWithEmptyEmail = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        email: '',
        createdAt: tDateTime,
      );
      final params = CreateUserParams(user: userWithEmptyEmail);

      when(mockUserRepository.createUser(userWithEmptyEmail))
          .thenAnswer((_) async => Right(userWithEmptyEmail));

      final result = await useCase(params);

      expect(result, equals(Right(userWithEmptyEmail)));
      verify(mockUserRepository.createUser(userWithEmptyEmail));
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      const tServerFailure = ServerFailure(
        message: 'Server error',
        code: 'SERVER_ERROR',
      );

      when(mockUserRepository.createUser(tUser))
          .thenAnswer((_) async => const Left(tServerFailure));

      final result = await useCase(tParams);

      expect(result, equals(const Left(tServerFailure)));
      verify(mockUserRepository.createUser(tUser));
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return NetworkFailure when network error occurs', () async {
      const tNetworkFailure = NetworkFailure(
        message: 'No internet connection',
        code: 'NETWORK_ERROR',
      );

      when(mockUserRepository.createUser(tUser))
          .thenAnswer((_) async => const Left(tNetworkFailure));

      final result = await useCase(tParams);

      expect(result, equals(const Left(tNetworkFailure)));
      verify(mockUserRepository.createUser(tUser));
      verifyNoMoreInteractions(mockUserRepository);
    });
  });

  group('CreateUserParams', () {
    final tDateTime = DateTime(2024, 1, 1);
    final tBirthDate = DateTime(1990, 5, 15);

    final tUser = User(
      id: '1',
      firstName: 'Juan',
      lastName: 'Pérez',
      dateOfBirth: tBirthDate,
      createdAt: tDateTime,
    );

    test('should be a subclass of UseCaseParams', () {
      final params = CreateUserParams(user: tUser);

      expect(params, isA<CreateUserParams>());
    });

    test('should return correct props for equality comparison', () {
      final params1 = CreateUserParams(user: tUser);
      final params2 = CreateUserParams(user: tUser);

      expect(params1, equals(params2));
      expect(params1.props, equals([tUser]));
    });

    test('should not be equal when users differ', () {
      final user2 = User(
        id: '2',
        firstName: 'María',
        lastName: 'García',
        dateOfBirth: tBirthDate,
        createdAt: tDateTime,
      );

      final params1 = CreateUserParams(user: tUser);
      final params2 = CreateUserParams(user: user2);

      expect(params1, isNot(equals(params2)));
    });
  });
}
