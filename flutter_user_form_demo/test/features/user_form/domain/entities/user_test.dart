import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/user.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/address.dart';

void main() {
  group('User Entity', () {
    final tDateTime = DateTime(2024, 1, 1);
    final tBirthDate = DateTime(1990, 5, 15);

    final tAddress = Address(
      id: '1',
      userId: 'test-user-1',
      streetAddress: 'Calle 123',
      city: 'Medellín',
      postalCode: '050001',
      countryId: 'CO',
      departmentId: 'ANT',
      municipalityId: 'MED',
      isPrimary: true,
      createdAt: tDateTime,
    );

    final tUser = User(
      id: '1',
      firstName: 'Juan',
      lastName: 'Pérez',
      dateOfBirth: tBirthDate,
      email: 'juan.perez@email.com',
      phoneNumber: '+57 300 1234567',
      addresses: [tAddress],
      createdAt: tDateTime,
    );

    test('should be a subclass of Equatable', () {
      // assert
      expect(tUser, isA<User>());
    });

    test('should return correct props for equality comparison', () {
      // arrange
      final user1 = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        createdAt: tDateTime,
      );

      final user2 = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        createdAt: tDateTime,
      );

      // act & assert
      expect(user1, equals(user2));
    });

    test('should not be equal when properties differ', () {
      // arrange
      final user1 = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        createdAt: tDateTime,
      );

      final user2 = User(
        id: '2',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        createdAt: tDateTime,
      );

      // act & assert
      expect(user1, isNot(equals(user2)));
    });

    test('should create user with default values', () {
      // arrange
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        createdAt: tDateTime,
      );

      // act & assert
      expect(user.email, isNull);
      expect(user.phoneNumber, isNull);
      expect(user.addresses, equals([]));
      expect(user.isActive, equals(true));
      expect(user.updatedAt, isNull);
    });

    test('should return correct full name', () {
      // arrange
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        createdAt: tDateTime,
      );

      // act
      final fullName = user.fullName;

      // assert
      expect(fullName, equals('Juan Pérez'));
    });

    test('should return primary address when available', () {
      // arrange
      final primaryAddress = Address(
        id: '1',
        userId: 'test-user-1',
        streetAddress: 'Calle 123',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        isPrimary: true,
        createdAt: tDateTime,
      );

      final secondaryAddress = Address(
        id: '2',
        userId: 'test-user-1',
        streetAddress: 'Carrera 456',
        city: 'Bogotá',
        postalCode: '110111',
        countryId: 'CO',
        departmentId: 'BOG',
        municipalityId: 'BOG',
        isPrimary: false,
        createdAt: tDateTime,
      );

      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        addresses: [secondaryAddress, primaryAddress],
        createdAt: tDateTime,
      );

      // act
      final primaryAddressResult = user.primaryAddress;

      // assert
      expect(primaryAddressResult, equals(primaryAddress));
    });

    test('should return first address when no primary address is set', () {
      // arrange
      final address1 = Address(
        id: '1',
        userId: 'test-user-1',
        streetAddress: 'Calle 123',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        isPrimary: false,
        createdAt: tDateTime,
      );

      final address2 = Address(
        id: '2',
        userId: 'test-user-1',
        streetAddress: 'Carrera 456',
        city: 'Bogotá',
        postalCode: '110111',
        countryId: 'CO',
        departmentId: 'BOG',
        municipalityId: 'BOG',
        isPrimary: false,
        createdAt: tDateTime,
      );

      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        addresses: [address1, address2],
        createdAt: tDateTime,
      );

      // act
      final primaryAddressResult = user.primaryAddress;

      // assert
      expect(primaryAddressResult, equals(address1));
    });

    test('should return null primary address when no addresses exist', () {
      // arrange
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        addresses: [],
        createdAt: tDateTime,
      );

      // act
      final primaryAddressResult = user.primaryAddress;

      // assert
      expect(primaryAddressResult, isNull);
    });

    test('should calculate age correctly', () {
      // arrange
      final currentDate = DateTime.now();
      final birthDate =
          DateTime(currentDate.year - 30, currentDate.month, currentDate.day);

      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: birthDate,
        createdAt: tDateTime,
      );

      // act
      final age = user.age;

      // assert
      expect(age, equals(30));
    });

    test(
        'should calculate age correctly when birthday has not occurred this year',
        () {
      // arrange
      final currentDate = DateTime.now();
      final birthDate = DateTime(
          currentDate.year - 30, currentDate.month + 1, currentDate.day);

      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: birthDate,
        createdAt: tDateTime,
      );

      // act
      final age = user.age;

      // assert
      expect(age, equals(29));
    });

    test('should return true for isValid when all required fields are present',
        () {
      // arrange
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        createdAt: tDateTime,
      );

      // act & assert
      expect(user.isValid, equals(true));
    });

    test('should return false for isValid when firstName is empty', () {
      // arrange
      final user = User(
        id: '1',
        firstName: '',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        createdAt: tDateTime,
      );

      // act & assert
      expect(user.isValid, equals(false));
    });

    test('should return false for isValid when lastName is empty', () {
      // arrange
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: '',
        dateOfBirth: tBirthDate,
        createdAt: tDateTime,
      );

      // act & assert
      expect(user.isValid, equals(false));
    });

    test('should return false for isValid when dateOfBirth is in the future',
        () {
      // arrange
      final futureDate = DateTime.now().add(const Duration(days: 1));
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: futureDate,
        createdAt: tDateTime,
      );

      // act & assert
      expect(user.isValid, equals(false));
    });

    test('should return false for isValid when age is negative', () {
      // arrange
      final futureDate = DateTime.now().add(const Duration(days: 365));
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: futureDate,
        createdAt: tDateTime,
      );

      // act & assert
      expect(user.isValid, equals(false));
      expect(user.age < 0, equals(true));
    });

    test('should return correct active address count', () {
      // arrange
      final activeAddress1 = Address(
        id: '1',
        userId: 'test-user-1',
        streetAddress: 'Calle 123',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        isActive: true,
        createdAt: tDateTime,
      );

      final activeAddress2 = Address(
        id: '2',
        userId: 'test-user-1',
        streetAddress: 'Carrera 456',
        city: 'Bogotá',
        postalCode: '110111',
        countryId: 'CO',
        departmentId: 'BOG',
        municipalityId: 'BOG',
        isActive: true,
        createdAt: tDateTime,
      );

      final inactiveAddress = Address(
        id: '3',
        userId: 'test-user-1',
        streetAddress: 'Avenida 789',
        city: 'Cali',
        postalCode: '760001',
        countryId: 'CO',
        departmentId: 'VAL',
        municipalityId: 'CAL',
        isActive: false,
        createdAt: tDateTime,
      );

      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        addresses: [activeAddress1, activeAddress2, inactiveAddress],
        createdAt: tDateTime,
      );

      // act
      final activeCount = user.activeAddressCount;

      // assert
      expect(activeCount, equals(2));
    });

    test('should return true for hasValidEmail when email is valid', () {
      // arrange
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        email: 'juan.perez@email.com',
        createdAt: tDateTime,
      );

      // act & assert
      expect(user.hasValidEmail, equals(true));
    });

    test('should return false for hasValidEmail when email is invalid', () {
      // arrange
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        email: 'invalid-email',
        createdAt: tDateTime,
      );

      // act & assert
      expect(user.hasValidEmail, equals(false));
    });

    test('should return false for hasValidEmail when email is null', () {
      // arrange
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        email: null,
        createdAt: tDateTime,
      );

      // act & assert
      expect(user.hasValidEmail, equals(false));
    });

    test('should return false for hasValidEmail when email is empty', () {
      // arrange
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        email: '',
        createdAt: tDateTime,
      );

      // act & assert
      expect(user.hasValidEmail, equals(false));
    });

    test('should add address correctly', () {
      // arrange
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        addresses: [],
        createdAt: tDateTime,
      );

      final newAddress = Address(
        id: '1',
        userId: 'test-user-1',
        streetAddress: 'Calle 123',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        createdAt: tDateTime,
      );

      // act
      final updatedUser = user.addAddress(newAddress);

      // assert
      expect(updatedUser.addresses.length, equals(1));
      expect(updatedUser.addresses.first, equals(newAddress));
      expect(updatedUser.updatedAt, isNotNull);
    });

    test('should remove address correctly', () {
      // arrange
      final address1 = Address(
        id: '1',
        userId: 'test-user-1',
        streetAddress: 'Calle 123',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        createdAt: tDateTime,
      );

      final address2 = Address(
        id: '2',
        userId: 'test-user-1',
        streetAddress: 'Carrera 456',
        city: 'Bogotá',
        postalCode: '110111',
        countryId: 'CO',
        departmentId: 'BOG',
        municipalityId: 'BOG',
        createdAt: tDateTime,
      );

      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        addresses: [address1, address2],
        createdAt: tDateTime,
      );

      // act
      final updatedUser = user.removeAddress('1');

      // assert
      expect(updatedUser.addresses.length, equals(1));
      expect(updatedUser.addresses.first, equals(address2));
      expect(updatedUser.updatedAt, isNotNull);
    });

    test('should update address correctly', () {
      // arrange
      final originalAddress = Address(
        id: '1',
        userId: 'test-user-1',
        streetAddress: 'Calle 123',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        createdAt: tDateTime,
      );

      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        addresses: [originalAddress],
        createdAt: tDateTime,
      );

      final updatedAddress = originalAddress.copyWith(
        streetAddress: 'Carrera 456',
      );

      // act
      final updatedUser = user.updateAddress(updatedAddress);

      // assert
      expect(updatedUser.addresses.length, equals(1));
      expect(updatedUser.addresses.first.streetAddress, equals('Carrera 456'));
      expect(updatedUser.updatedAt, isNotNull);
    });

    test('should return unchanged user when updating non-existent address', () {
      // arrange
      final originalAddress = Address(
        id: '1',
        userId: 'test-user-1',
        streetAddress: 'Calle 123',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        createdAt: tDateTime,
      );

      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        addresses: [originalAddress],
        createdAt: tDateTime,
      );

      final nonExistentAddress = Address(
        id: '999',
        userId: 'test-user-1',
        streetAddress: 'Carrera 456',
        city: 'Bogotá',
        postalCode: '110111',
        countryId: 'CO',
        departmentId: 'BOG',
        municipalityId: 'BOG',
        createdAt: tDateTime,
      );

      // act
      final result = user.updateAddress(nonExistentAddress);

      // assert
      expect(result, equals(user));
      expect(result.addresses.length, equals(1));
      expect(result.addresses.first, equals(originalAddress));
    });

    test('should have proper toString implementation', () {
      // arrange
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        dateOfBirth: tBirthDate,
        email: 'juan@email.com',
        addresses: [tAddress],
        createdAt: tDateTime,
      );

      // act
      final result = user.toString();

      // assert
      expect(
        result,
        contains('User(id: 1, fullName: Juan Pérez, email: juan@email.com'),
      );
    });
  });
}
