import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/country.dart';

void main() {
  group('Country Entity', () {
    const tCountry = Country(
      id: '1',
      name: 'Colombia',
      code: 'CO',
      isActive: true,
    );

    test('should be a subclass of Equatable', () {
      // assert
      expect(tCountry, isA<Country>());
    });

    test('should return correct props for equality comparison', () {
      // arrange
      const country1 = Country(
        id: '1',
        name: 'Colombia',
        code: 'CO',
        isActive: true,
      );

      const country2 = Country(
        id: '1',
        name: 'Colombia',
        code: 'CO',
        isActive: true,
      );

      // act & assert
      expect(country1, equals(country2));
      expect(
          country1.props,
          equals(
              [country1.id, country1.name, country1.code, country1.isActive]));
    });

    test('should not be equal when properties differ', () {
      // arrange
      const country1 = Country(
        id: '1',
        name: 'Colombia',
        code: 'CO',
        isActive: true,
      );

      const country2 = Country(
        id: '2',
        name: 'Colombia',
        code: 'CO',
        isActive: true,
      );

      // act & assert
      expect(country1, isNot(equals(country2)));
    });

    test('should create country with default isActive value', () {
      // arrange
      const country = Country(
        id: '1',
        name: 'Colombia',
        code: 'CO',
      );

      // act & assert
      expect(country.isActive, equals(true));
    });

    test('should create country copy with updated values', () {
      // arrange
      const originalCountry = Country(
        id: '1',
        name: 'Colombia',
        code: 'CO',
        isActive: true,
      );

      // act
      final updatedCountry = originalCountry.copyWith(
        name: 'Updated Colombia',
        isActive: false,
      );

      // assert
      expect(updatedCountry.id, equals(originalCountry.id));
      expect(updatedCountry.code, equals(originalCountry.code));
      expect(updatedCountry.name, equals('Updated Colombia'));
      expect(updatedCountry.isActive, equals(false));
    });

    test(
        'should create country copy without changes when no parameters provided',
        () {
      // arrange
      const originalCountry = Country(
        id: '1',
        name: 'Colombia',
        code: 'CO',
        isActive: true,
      );

      // act
      final copiedCountry = originalCountry.copyWith();

      // assert
      expect(copiedCountry, equals(originalCountry));
    });

    test('should have proper toString implementation', () {
      // arrange
      const country = Country(
        id: '1',
        name: 'Colombia',
        code: 'CO',
        isActive: true,
      );

      // act
      final result = country.toString();

      // assert
      expect(
        result,
        equals('Country(id: 1, name: Colombia, code: CO, isActive: true)'),
      );
    });

    test('should handle empty strings in properties', () {
      // arrange
      const country = Country(
        id: '',
        name: '',
        code: '',
        isActive: false,
      );

      // act & assert
      expect(country.id, equals(''));
      expect(country.name, equals(''));
      expect(country.code, equals(''));
      expect(country.isActive, equals(false));
    });

    test('should handle special characters in properties', () {
      // arrange
      const country = Country(
        id: '123-abc',
        name: 'País con ñ y acentos',
        code: 'ES',
        isActive: true,
      );

      // act & assert
      expect(country.id, equals('123-abc'));
      expect(country.name, equals('País con ñ y acentos'));
      expect(country.code, equals('ES'));
      expect(country.isActive, equals(true));
    });
  });
}
