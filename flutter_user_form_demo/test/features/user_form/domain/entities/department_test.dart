import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/department.dart';

void main() {
  group('Department Entity', () {
    const tDepartment = Department(
      id: '1',
      name: 'Antioquia',
      code: 'ANT',
      countryId: 'CO',
      isActive: true,
    );

    test('should be a subclass of Equatable', () {
      // assert
      expect(tDepartment, isA<Department>());
    });

    test('should return correct props for equality comparison', () {
      // arrange
      const department1 = Department(
        id: '1',
        name: 'Antioquia',
        code: 'ANT',
        countryId: 'CO',
        isActive: true,
      );

      const department2 = Department(
        id: '1',
        name: 'Antioquia',
        code: 'ANT',
        countryId: 'CO',
        isActive: true,
      );

      // act & assert
      expect(department1, equals(department2));
      expect(
        department1.props,
        equals([
          department1.id,
          department1.name,
          department1.code,
          department1.countryId,
          department1.isActive,
        ]),
      );
    });

    test('should not be equal when properties differ', () {
      // arrange
      const department1 = Department(
        id: '1',
        name: 'Antioquia',
        code: 'ANT',
        countryId: 'CO',
        isActive: true,
      );

      const department2 = Department(
        id: '2',
        name: 'Antioquia',
        code: 'ANT',
        countryId: 'CO',
        isActive: true,
      );

      // act & assert
      expect(department1, isNot(equals(department2)));
    });

    test('should create department with default isActive value', () {
      // arrange
      const department = Department(
        id: '1',
        name: 'Antioquia',
        code: 'ANT',
        countryId: 'CO',
      );

      // act & assert
      expect(department.isActive, equals(true));
    });

    test('should create department copy with updated values', () {
      // arrange
      const originalDepartment = Department(
        id: '1',
        name: 'Antioquia',
        code: 'ANT',
        countryId: 'CO',
        isActive: true,
      );

      // act
      final updatedDepartment = originalDepartment.copyWith(
        name: 'Updated Antioquia',
        countryId: 'COL',
        isActive: false,
      );

      // assert
      expect(updatedDepartment.id, equals(originalDepartment.id));
      expect(updatedDepartment.code, equals(originalDepartment.code));
      expect(updatedDepartment.name, equals('Updated Antioquia'));
      expect(updatedDepartment.countryId, equals('COL'));
      expect(updatedDepartment.isActive, equals(false));
    });

    test(
        'should create department copy without changes when no parameters provided',
        () {
      // arrange
      const originalDepartment = Department(
        id: '1',
        name: 'Antioquia',
        code: 'ANT',
        countryId: 'CO',
        isActive: true,
      );

      // act
      final copiedDepartment = originalDepartment.copyWith();

      // assert
      expect(copiedDepartment, equals(originalDepartment));
    });

    test('should have proper toString implementation', () {
      // arrange
      const department = Department(
        id: '1',
        name: 'Antioquia',
        code: 'ANT',
        countryId: 'CO',
        isActive: true,
      );

      // act
      final result = department.toString();

      // assert
      expect(
        result,
        equals(
            'Department(id: 1, name: Antioquia, code: ANT, countryId: CO, isActive: true)'),
      );
    });

    test('should handle empty strings in properties', () {
      // arrange
      const department = Department(
        id: '',
        name: '',
        code: '',
        countryId: '',
        isActive: false,
      );

      // act & assert
      expect(department.id, equals(''));
      expect(department.name, equals(''));
      expect(department.code, equals(''));
      expect(department.countryId, equals(''));
      expect(department.isActive, equals(false));
    });

    test('should handle special characters in properties', () {
      // arrange
      const department = Department(
        id: '123-abc',
        name: 'Departamento con ñ',
        code: 'DÑ',
        countryId: 'country-123',
        isActive: true,
      );

      // act & assert
      expect(department.id, equals('123-abc'));
      expect(department.name, equals('Departamento con ñ'));
      expect(department.code, equals('DÑ'));
      expect(department.countryId, equals('country-123'));
      expect(department.isActive, equals(true));
    });

    test('should not be equal when countryId differs', () {
      // arrange
      const department1 = Department(
        id: '1',
        name: 'Antioquia',
        code: 'ANT',
        countryId: 'CO',
        isActive: true,
      );

      const department2 = Department(
        id: '1',
        name: 'Antioquia',
        code: 'ANT',
        countryId: 'VE',
        isActive: true,
      );

      // act & assert
      expect(department1, isNot(equals(department2)));
    });
  });
}
