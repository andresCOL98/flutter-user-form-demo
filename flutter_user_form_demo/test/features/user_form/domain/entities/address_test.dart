import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/address.dart';

void main() {
  group('Address Entity', () {
    final tDateTime = DateTime(2024, 1, 1);
    final tUpdatedDateTime = DateTime(2024, 2, 1);

    final tAddress = Address(
      id: '1',
      streetAddress: 'Calle 123 #45-67',
      city: 'Medellín',
      postalCode: '050001',
      countryId: 'CO',
      departmentId: 'ANT',
      municipalityId: 'MED',
      createdAt: tDateTime,
    );

    test('should be a subclass of Equatable', () {
      // assert
      expect(tAddress, isA<Address>());
    });

    test('should return correct props for equality comparison', () {
      // arrange
      final address1 = Address(
        id: '1',
        streetAddress: 'Calle 123',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        createdAt: tDateTime,
      );

      final address2 = Address(
        id: '1',
        streetAddress: 'Calle 123',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        createdAt: tDateTime,
      );

      // act & assert
      expect(address1, equals(address2));
    });

    test('should not be equal when properties differ', () {
      // arrange
      final address1 = Address(
        id: '1',
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
        streetAddress: 'Calle 123',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        createdAt: tDateTime,
      );

      // act & assert
      expect(address1, isNot(equals(address2)));
    });

    test('should create address with default values', () {
      // arrange
      final address = Address(
        id: '1',
        streetAddress: 'Calle 123',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        createdAt: tDateTime,
      );

      // act & assert
      expect(address.streetAddress2, isNull);
      expect(address.notes, isNull);
      expect(address.isPrimary, equals(false));
      expect(address.isActive, equals(true));
      expect(address.updatedAt, isNull);
    });

    test('should create address copy with updated values', () {
      // arrange
      final originalAddress = Address(
        id: '1',
        streetAddress: 'Calle 123',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        createdAt: tDateTime,
      );

      // act
      final updatedAddress = originalAddress.copyWith(
        streetAddress: 'Carrera 456',
        isPrimary: true,
        updatedAt: tUpdatedDateTime,
      );

      // assert
      expect(updatedAddress.id, equals(originalAddress.id));
      expect(updatedAddress.streetAddress, equals('Carrera 456'));
      expect(updatedAddress.city, equals(originalAddress.city));
      expect(updatedAddress.isPrimary, equals(true));
      expect(updatedAddress.updatedAt, equals(tUpdatedDateTime));
    });

    test('should return formatted address without streetAddress2', () {
      // arrange
      final address = Address(
        id: '1',
        streetAddress: 'Calle 123 #45-67',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        createdAt: tDateTime,
      );

      // act
      final formattedAddress = address.formattedAddress;

      // assert
      expect(formattedAddress, equals('Calle 123 #45-67, Medellín, 050001'));
    });

    test('should return formatted address with streetAddress2', () {
      // arrange
      final address = Address(
        id: '1',
        streetAddress: 'Calle 123',
        streetAddress2: 'Apartamento 45',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        createdAt: tDateTime,
      );

      // act
      final formattedAddress = address.formattedAddress;

      // assert
      expect(formattedAddress,
          equals('Calle 123, Apartamento 45, Medellín, 050001'));
    });

    test('should return formatted address with notes', () {
      // arrange
      final address = Address(
        id: '1',
        streetAddress: 'Calle 123',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        notes: 'Al lado del parque',
        createdAt: tDateTime,
      );

      // act
      final formattedAddress = address.formattedAddress;

      // assert
      expect(formattedAddress,
          equals('Calle 123, Medellín, 050001 (Al lado del parque)'));
    });

    test('should return true for isValid when all required fields are present',
        () {
      // arrange
      final address = Address(
        id: '1',
        streetAddress: 'Calle 123',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        createdAt: tDateTime,
      );

      // act & assert
      expect(address.isValid, equals(true));
    });

    test('should return false for isValid when streetAddress is empty', () {
      // arrange
      final address = Address(
        id: '1',
        streetAddress: '',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        createdAt: tDateTime,
      );

      // act & assert
      expect(address.isValid, equals(false));
    });

    test('should return false for isValid when city is empty', () {
      // arrange
      final address = Address(
        id: '1',
        streetAddress: 'Calle 123',
        city: '',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        createdAt: tDateTime,
      );

      // act & assert
      expect(address.isValid, equals(false));
    });

    test('should return false for isValid when postalCode is empty', () {
      // arrange
      final address = Address(
        id: '1',
        streetAddress: 'Calle 123',
        city: 'Medellín',
        postalCode: '',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        createdAt: tDateTime,
      );

      // act & assert
      expect(address.isValid, equals(false));
    });

    test('should return false for isValid when location IDs are empty', () {
      // arrange
      final address = Address(
        id: '1',
        streetAddress: 'Calle 123',
        city: 'Medellín',
        postalCode: '050001',
        countryId: '',
        departmentId: 'ANT',
        municipalityId: 'MED',
        createdAt: tDateTime,
      );

      // act & assert
      expect(address.isValid, equals(false));
    });

    test('should have proper toString implementation', () {
      // arrange
      final address = Address(
        id: '1',
        streetAddress: 'Calle 123',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        isPrimary: true,
        isActive: true,
        createdAt: tDateTime,
      );

      // act
      final result = address.toString();

      // assert
      expect(
        result,
        equals(
            'Address(id: 1, streetAddress: Calle 123, city: Medellín, postalCode: 050001, isPrimary: true, isActive: true)'),
      );
    });

    test('should handle null optional fields in formatted address', () {
      // arrange
      final address = Address(
        id: '1',
        streetAddress: 'Calle 123',
        streetAddress2: null,
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        notes: null,
        createdAt: tDateTime,
      );

      // act
      final formattedAddress = address.formattedAddress;

      // assert
      expect(formattedAddress, equals('Calle 123, Medellín, 050001'));
    });

    test('should handle empty optional fields in formatted address', () {
      // arrange
      final address = Address(
        id: '1',
        streetAddress: 'Calle 123',
        streetAddress2: '',
        city: 'Medellín',
        postalCode: '050001',
        countryId: 'CO',
        departmentId: 'ANT',
        municipalityId: 'MED',
        notes: '',
        createdAt: tDateTime,
      );

      // act
      final formattedAddress = address.formattedAddress;

      // assert
      expect(formattedAddress, equals('Calle 123, Medellín, 050001'));
    });
  });
}
