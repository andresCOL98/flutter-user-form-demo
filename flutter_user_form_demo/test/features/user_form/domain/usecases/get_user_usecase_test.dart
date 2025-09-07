import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_user_form_demo/core/errors/failures.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/user.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/usecases/get_user_usecase.dart';

import '../../../../helpers/test_mocks.dart';

void main() {
  late GetUserUseCase useCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    useCase = GetUserUseCase(mockUserRepository);
  });

  group('GetUserUseCase', () {
    const tUserId = '1';
    final tDateTime = DateTime(2024, 1, 1);
    final tBirthDate = DateTime(1990, 5, 15);

    final tUser = User(
      id: tUserId,
      firstName: 'Juan',
      lastName: 'Pérez',
      dateOfBirth: tBirthDate,
      email: 'juan.perez@email.com',
      createdAt: tDateTime,
    );

    const tParams = GetUserParams(userId: tUserId);

    test('should get user successfully when user exists', () async {
      when(mockUserRepository.getUserById(tUserId))
          .thenAnswer((_) async => Right(tUser));

      final result = await useCase(tParams);

      expect(result, equals(Right(tUser)));
      verify(mockUserRepository.getUserById(tUserId));
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return ValidationFailure when userId is empty', () async {
      const emptyParams = GetUserParams(userId: '');

      final result = await useCase(emptyParams);

      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, equals('User ID cannot be empty'));
          expect(failure.code, equals('EMPTY_USER_ID'));
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

      when(mockUserRepository.getUserById(tUserId))
          .thenAnswer((_) async => const Left(tNotFoundFailure));

      final result = await useCase(tParams);

      expect(result, equals(const Left(tNotFoundFailure)));
      verify(mockUserRepository.getUserById(tUserId));
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      const tServerFailure = ServerFailure(
        message: 'Server error',
        code: 'SERVER_ERROR',
      );

      when(mockUserRepository.getUserById(tUserId))
          .thenAnswer((_) async => const Left(tServerFailure));

      final result = await useCase(tParams);

      expect(result, equals(const Left(tServerFailure)));
      verify(mockUserRepository.getUserById(tUserId));
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return NetworkFailure when network error occurs', () async {
      const tNetworkFailure = NetworkFailure(
        message: 'No internet connection',
        code: 'NETWORK_ERROR',
      );

      when(mockUserRepository.getUserById(tUserId))
          .thenAnswer((_) async => const Left(tNetworkFailure));

      final result = await useCase(tParams);

      expect(result, equals(const Left(tNetworkFailure)));
      verify(mockUserRepository.getUserById(tUserId));
      verifyNoMoreInteractions(mockUserRepository);
    });
  });

  group('GetUserParams', () {
    const tUserId = '1';

    test('should be a subclass of UseCaseParams', () {
      const params = GetUserParams(userId: tUserId);

      expect(params, isA<GetUserParams>());
    });

    test('should return correct props for equality comparison', () {
      const params1 = GetUserParams(userId: tUserId);
      const params2 = GetUserParams(userId: tUserId);

      expect(params1, equals(params2));
      expect(params1.props, equals([tUserId]));
    });

    test('should not be equal when userIds differ', () {
      const params1 = GetUserParams(userId: '1');
      const params2 = GetUserParams(userId: '2');

      expect(params1, isNot(equals(params2)));
    });
  });
}
