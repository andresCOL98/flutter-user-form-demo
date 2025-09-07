import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_user_form_demo/core/errors/failures.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/user.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/address.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/usecases/add_address_usecase.dart';

import '../../../../helpers/test_mocks.dart';

void main() {
  late AddAddressUseCase useCase;
  late MockUserRepository mockUserRepository;
  late MockLocationRepository mockLocationRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockLocationRepository = MockLocationRepository();
    useCase = AddAddressUseCase(
      userRepository: mockUserRepository,
      locationRepository: mockLocationRepository,
    );
  });

  group('AddAddressUseCase', () {
    const tUserId = '1';
    final tDateTime = DateTime(2024, 1, 1);
    final tBirthDate = DateTime(1990, 5, 15);

    final tAddress = Address(
      id: 'addr_1',
      streetAddress: 'Calle 123 #45-67',
      city: 'Medellín',
      postalCode: '050001',
      countryId: 'CO',
      departmentId: 'ANT',
      municipalityId: 'MED',
      isPrimary: false,
      createdAt: tDateTime,
    );

    final tUser = User(
      id: tUserId,
      firstName: 'Juan',
      lastName: 'Pérez',
      dateOfBirth: tBirthDate,
      createdAt: tDateTime,
    );

    final tUserWithAddress = tUser.addAddress(tAddress);

    final tParams = AddAddressParams(
      userId: tUserId,
      address: tAddress,
    );

    test('should add address successfully when all validations pass', () async {
      when(mockLocationRepository.validateLocationHierarchy(
        tAddress.countryId,
        tAddress.departmentId,
        tAddress.municipalityId,
      )).thenAnswer((_) async => const Right(true));

      when(mockUserRepository.addAddressToUser(tUserId, tAddress))
          .thenAnswer((_) async => Right(tUserWithAddress));

      final result = await useCase(tParams);

      expect(result, equals(Right(tUserWithAddress)));
      verify(mockLocationRepository.validateLocationHierarchy(
        tAddress.countryId,
        tAddress.departmentId,
        tAddress.municipalityId,
      ));
      verify(mockUserRepository.addAddressToUser(tUserId, tAddress));
      verifyNoMoreInteractions(mockUserRepository);
      verifyNoMoreInteractions(mockLocationRepository);
    });

    test('should return ValidationFailure when userId is empty', () async {
      final invalidParams = AddAddressParams(
        userId: '',
        address: tAddress,
      );

      final result = await useCase(invalidParams);

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
      verifyZeroInteractions(mockLocationRepository);
    });

    test('should return ValidationFailure when address is invalid', () async {
      final invalidAddress = Address(
        id: 'addr_1',
        streetAddress: '',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        createdAt: tDateTime,
      );

      final invalidParams = AddAddressParams(
        userId: tUserId,
        address: invalidAddress,
      );

      final result = await useCase(invalidParams);

      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, equals('Invalid address data provided'));
          expect(failure.code, equals('INVALID_ADDRESS_DATA'));
        },
        (user) => fail('Should return failure'),
      );
      verifyZeroInteractions(mockUserRepository);
      verifyZeroInteractions(mockLocationRepository);
    });

    test('should return ValidationFailure when location hierarchy is invalid',
        () async {
      when(mockLocationRepository.validateLocationHierarchy(
        tAddress.countryId,
        tAddress.departmentId,
        tAddress.municipalityId,
      )).thenAnswer((_) async => const Right(false)); // Invalid hierarchy

      final result = await useCase(tParams);

      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, equals('Invalid location hierarchy'));
          expect(failure.code, equals('INVALID_LOCATION_HIERARCHY'));
        },
        (user) => fail('Should return failure'),
      );
      verify(mockLocationRepository.validateLocationHierarchy(
        tAddress.countryId,
        tAddress.departmentId,
        tAddress.municipalityId,
      ));
      verifyZeroInteractions(mockUserRepository);
      verifyNoMoreInteractions(mockLocationRepository);
    });

    test('should return failure when location repository validation fails',
        () async {
      const tServerFailure = ServerFailure(
        message: 'Location service error',
        code: 'LOCATION_SERVICE_ERROR',
      );

      when(mockLocationRepository.validateLocationHierarchy(
        tAddress.countryId,
        tAddress.departmentId,
        tAddress.municipalityId,
      )).thenAnswer((_) async => const Left(tServerFailure));

      final result = await useCase(tParams);

      expect(result, equals(const Left(tServerFailure)));
      verify(mockLocationRepository.validateLocationHierarchy(
        tAddress.countryId,
        tAddress.departmentId,
        tAddress.municipalityId,
      ));
      verifyZeroInteractions(mockUserRepository);
      verifyNoMoreInteractions(mockLocationRepository);
    });

    test('should return failure when user repository fails', () async {
      const tNotFoundFailure = NotFoundFailure(
        message: 'User not found',
        code: 'USER_NOT_FOUND',
      );

      when(mockLocationRepository.validateLocationHierarchy(
        tAddress.countryId,
        tAddress.departmentId,
        tAddress.municipalityId,
      )).thenAnswer((_) async => const Right(true));

      when(mockUserRepository.addAddressToUser(tUserId, tAddress))
          .thenAnswer((_) async => const Left(tNotFoundFailure));

      final result = await useCase(tParams);

      expect(result, equals(const Left(tNotFoundFailure)));
      verify(mockLocationRepository.validateLocationHierarchy(
        tAddress.countryId,
        tAddress.departmentId,
        tAddress.municipalityId,
      ));
      verify(mockUserRepository.addAddressToUser(tUserId, tAddress));
      verifyNoMoreInteractions(mockUserRepository);
      verifyNoMoreInteractions(mockLocationRepository);
    });

    test('should handle address with all optional fields', () async {
      final completeAddress = Address(
        id: 'addr_2',
        streetAddress: 'Carrera 456',
        streetAddress2: 'Apartamento 123',
        city: 'Bogotá',
        postalCode: '110111',
        countryId: 'CO',
        departmentId: 'BOG',
        municipalityId: 'BOG',
        notes: 'Cerca del centro comercial',
        isPrimary: true,
        createdAt: tDateTime,
      );

      final userWithCompleteAddress = tUser.addAddress(completeAddress);

      final completeParams = AddAddressParams(
        userId: tUserId,
        address: completeAddress,
      );

      when(mockLocationRepository.validateLocationHierarchy(
        completeAddress.countryId,
        completeAddress.departmentId,
        completeAddress.municipalityId,
      )).thenAnswer((_) async => const Right(true));

      when(mockUserRepository.addAddressToUser(tUserId, completeAddress))
          .thenAnswer((_) async => Right(userWithCompleteAddress));

      final result = await useCase(completeParams);

      expect(result, equals(Right(userWithCompleteAddress)));
      verify(mockLocationRepository.validateLocationHierarchy(
        completeAddress.countryId,
        completeAddress.departmentId,
        completeAddress.municipalityId,
      ));
      verify(mockUserRepository.addAddressToUser(tUserId, completeAddress));
    });
  });

  group('AddAddressParams', () {
    final tDateTime = DateTime(2024, 1, 1);
    const tUserId = '1';

    final tAddress = Address(
      id: 'addr_1',
      streetAddress: 'Calle 123',
      city: 'Medellín',
      postalCode: '050001',
      countryId: 'CO',
      departmentId: 'ANT',
      municipalityId: 'MED',
      createdAt: tDateTime,
    );

    test('should be a subclass of UseCaseParams', () {
      final params = AddAddressParams(userId: tUserId, address: tAddress);

      expect(params, isA<AddAddressParams>());
    });

    test('should return correct props for equality comparison', () {
      final params1 = AddAddressParams(userId: tUserId, address: tAddress);
      final params2 = AddAddressParams(userId: tUserId, address: tAddress);

      expect(params1, equals(params2));
      expect(params1.props, equals([tUserId, tAddress]));
    });

    test('should not be equal when userId differs', () {
      final params1 = AddAddressParams(userId: '1', address: tAddress);
      final params2 = AddAddressParams(userId: '2', address: tAddress);

      expect(params1, isNot(equals(params2)));
    });

    test('should not be equal when address differs', () {
      final address2 = Address(
        id: 'addr_2',
        streetAddress: 'Carrera 456',
        city: 'Bogotá',
        postalCode: '110111',
        countryId: 'CO',
        departmentId: 'BOG',
        municipalityId: 'BOG',
        createdAt: tDateTime,
      );

      final params1 = AddAddressParams(userId: tUserId, address: tAddress);
      final params2 = AddAddressParams(userId: tUserId, address: address2);

      expect(params1, isNot(equals(params2)));
    });
  });
}
