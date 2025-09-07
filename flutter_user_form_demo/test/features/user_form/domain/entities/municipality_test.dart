import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/municipality.dart';

void main() {
  group('Municipality Entity', () {
    const tMunicipality = Municipality(
      id: '1',
      name: 'Medellín',
      code: 'MED',
      departmentId: 'ANT',
      isActive: true,
    );

    test('should be a subclass of Equatable', () {
      // assert
      expect(tMunicipality, isA<Municipality>());
    });

    test('should return correct props for equality comparison', () {
      // arrange
      const municipality1 = Municipality(
        id: '1',
        name: 'Medellín',
        code: 'MED',
        departmentId: 'ANT',
        isActive: true,
      );

      const municipality2 = Municipality(
        id: '1',
        name: 'Medellín',
        code: 'MED',
        departmentId: 'ANT',
        isActive: true,
      );

      // act & assert
      expect(municipality1, equals(municipality2));
      expect(
        municipality1.props,
        equals([
          municipality1.id,
          municipality1.name,
          municipality1.code,
          municipality1.departmentId,
          municipality1.isActive,
        ]),
      );
    });

    test('should not be equal when properties differ', () {
      // arrange
      const municipality1 = Municipality(
        id: '1',
        name: 'Medellín',
        code: 'MED',
        departmentId: 'ANT',
        isActive: true,
      );

      const municipality2 = Municipality(
        id: '2',
        name: 'Medellín',
        code: 'MED',
        departmentId: 'ANT',
        isActive: true,
      );

      // act & assert
      expect(municipality1, isNot(equals(municipality2)));
    });

    test('should create municipality with default isActive value', () {
      // arrange
      const municipality = Municipality(
        id: '1',
        name: 'Medellín',
        code: 'MED',
        departmentId: 'ANT',
      );

      // act & assert
      expect(municipality.isActive, equals(true));
    });

    test('should create municipality copy with updated values', () {
      // arrange
      const originalMunicipality = Municipality(
        id: '1',
        name: 'Medellín',
        code: 'MED',
        departmentId: 'ANT',
        isActive: true,
      );

      // act
      final updatedMunicipality = originalMunicipality.copyWith(
        name: 'Updated Medellín',
        departmentId: 'BOG',
        isActive: false,
      );

      // assert
      expect(updatedMunicipality.id, equals(originalMunicipality.id));
      expect(updatedMunicipality.code, equals(originalMunicipality.code));
      expect(updatedMunicipality.name, equals('Updated Medellín'));
      expect(updatedMunicipality.departmentId, equals('BOG'));
      expect(updatedMunicipality.isActive, equals(false));
    });

    test(
        'should create municipality copy without changes when no parameters provided',
        () {
      // arrange
      const originalMunicipality = Municipality(
        id: '1',
        name: 'Medellín',
        code: 'MED',
        departmentId: 'ANT',
        isActive: true,
      );

      // act
      final copiedMunicipality = originalMunicipality.copyWith();

      // assert
      expect(copiedMunicipality, equals(originalMunicipality));
    });

    test('should have proper toString implementation', () {
      // arrange
      const municipality = Municipality(
        id: '1',
        name: 'Medellín',
        code: 'MED',
        departmentId: 'ANT',
        isActive: true,
      );

      // act
      final result = municipality.toString();

      // assert
      expect(
        result,
        equals(
            'Municipality(id: 1, name: Medellín, code: MED, departmentId: ANT, isActive: true)'),
      );
    });

    test('should handle empty strings in properties', () {
      // arrange
      const municipality = Municipality(
        id: '',
        name: '',
        code: '',
        departmentId: '',
        isActive: false,
      );

      // act & assert
      expect(municipality.id, equals(''));
      expect(municipality.name, equals(''));
      expect(municipality.code, equals(''));
      expect(municipality.departmentId, equals(''));
      expect(municipality.isActive, equals(false));
    });

    test('should handle special characters in properties', () {
      // arrange
      const municipality = Municipality(
        id: '123-abc',
        name: 'Municipio con ñ y acentós',
        code: 'MÑ',
        departmentId: 'dep-123',
        isActive: true,
      );

      // act & assert
      expect(municipality.id, equals('123-abc'));
      expect(municipality.name, equals('Municipio con ñ y acentós'));
      expect(municipality.code, equals('MÑ'));
      expect(municipality.departmentId, equals('dep-123'));
      expect(municipality.isActive, equals(true));
    });

    test('should not be equal when departmentId differs', () {
      // arrange
      const municipality1 = Municipality(
        id: '1',
        name: 'Medellín',
        code: 'MED',
        departmentId: 'ANT',
        isActive: true,
      );

      const municipality2 = Municipality(
        id: '1',
        name: 'Medellín',
        code: 'MED',
        departmentId: 'BOG',
        isActive: true,
      );

      // act & assert
      expect(municipality1, isNot(equals(municipality2)));
    });
  });
}
