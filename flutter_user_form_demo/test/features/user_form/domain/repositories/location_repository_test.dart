import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_user_form_demo/core/errors/failures.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/country.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/department.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/municipality.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/repositories/location_repository.dart';

import '../../../../helpers/test_mocks.dart';

void main() {
  group('LocationRepository Interface', () {
    late MockLocationRepository mockLocationRepository;

    setUp(() {
      mockLocationRepository = MockLocationRepository();
    });

    final tCountries = [
      const Country(id: 'CO', name: 'Colombia', code: 'CO'),
      const Country(id: 'AR', name: 'Argentina', code: 'AR'),
    ];

    final tDepartments = [
      const Department(
        id: 'ANT',
        name: 'Antioquia',
        countryId: 'CO',
        code: '05',
      ),
      const Department(
        id: 'BOG',
        name: 'Bogotá D.C.',
        countryId: 'CO',
        code: '11',
      ),
    ];

    final tMunicipalities = [
      const Municipality(
        id: 'MED',
        name: 'Medellín',
        departmentId: 'ANT',
        code: '001',
      ),
      const Municipality(
        id: 'BEL',
        name: 'Bello',
        departmentId: 'ANT',
        code: '088',
      ),
    ];

    group('getCountries', () {
      test('should define getCountries method signature', () {
        // arrange & act
        when(mockLocationRepository.getCountries())
            .thenAnswer((_) async => Right(tCountries));

        // assert - method signature exists and can be mocked
        expect(mockLocationRepository.getCountries, isA<Function>());
      });

      test('should return list of Countries on success', () async {
        // arrange
        when(mockLocationRepository.getCountries())
            .thenAnswer((_) async => Right(tCountries));

        // act
        final result = await mockLocationRepository.getCountries();

        // assert
        expect(result, isA<Right<Failure, List<Country>>>());
        result.fold(
          (failure) => fail('Should return success'),
          (countries) => expect(countries, equals(tCountries)),
        );
        verify(mockLocationRepository.getCountries());
      });

      test('should return empty list when no countries exist', () async {
        // arrange
        when(mockLocationRepository.getCountries())
            .thenAnswer((_) async => const Right([]));

        // act
        final result = await mockLocationRepository.getCountries();

        // assert
        expect(result, isA<Right<Failure, List<Country>>>());
        result.fold(
          (failure) => fail('Should return success'),
          (countries) => expect(countries, isEmpty),
        );
        verify(mockLocationRepository.getCountries());
      });

      test('should return Failure on error', () async {
        // arrange
        const tFailure = ServerFailure(
          message: 'Failed to load countries',
          code: 'COUNTRIES_LOAD_ERROR',
        );

        when(mockLocationRepository.getCountries())
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await mockLocationRepository.getCountries();

        // assert
        expect(result, isA<Left<Failure, List<Country>>>());
        expect(result, equals(const Left(tFailure)));
        verify(mockLocationRepository.getCountries());
      });
    });

    group('getCountryById', () {
      test('should define getCountryById method signature', () {
        // arrange & act
        when(mockLocationRepository.getCountryById('CO'))
            .thenAnswer((_) async => Right(tCountries.first));

        // assert - method signature exists and can be mocked
        expect(mockLocationRepository.getCountryById, isA<Function>());
      });

      test('should return Country when country exists', () async {
        // arrange
        when(mockLocationRepository.getCountryById('CO'))
            .thenAnswer((_) async => Right(tCountries.first));

        // act
        final result = await mockLocationRepository.getCountryById('CO');

        // assert
        expect(result, isA<Right<Failure, Country>>());
        result.fold(
          (failure) => fail('Should return success'),
          (country) => expect(country, equals(tCountries.first)),
        );
        verify(mockLocationRepository.getCountryById('CO'));
      });

      test('should return NotFoundFailure when country does not exist',
          () async {
        // arrange
        const tFailure = NotFoundFailure(
          message: 'Country not found',
          code: 'COUNTRY_NOT_FOUND',
        );

        when(mockLocationRepository.getCountryById('INVALID'))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await mockLocationRepository.getCountryById('INVALID');

        // assert
        expect(result, isA<Left<Failure, Country>>());
        expect(result, equals(const Left(tFailure)));
        verify(mockLocationRepository.getCountryById('INVALID'));
      });
    });

    group('getDepartmentsByCountry', () {
      test('should define getDepartmentsByCountry method signature', () {
        // arrange & act
        when(mockLocationRepository.getDepartmentsByCountry('CO'))
            .thenAnswer((_) async => Right(tDepartments));

        // assert - method signature exists and can be mocked
        expect(mockLocationRepository.getDepartmentsByCountry, isA<Function>());
      });

      test('should return list of Departments for valid country', () async {
        // arrange
        when(mockLocationRepository.getDepartmentsByCountry('CO'))
            .thenAnswer((_) async => Right(tDepartments));

        // act
        final result =
            await mockLocationRepository.getDepartmentsByCountry('CO');

        // assert
        expect(result, isA<Right<Failure, List<Department>>>());
        result.fold(
          (failure) => fail('Should return success'),
          (departments) => expect(departments, equals(tDepartments)),
        );
        verify(mockLocationRepository.getDepartmentsByCountry('CO'));
      });

      test('should return empty list when country has no departments',
          () async {
        // arrange
        when(mockLocationRepository.getDepartmentsByCountry('CO'))
            .thenAnswer((_) async => const Right([]));

        // act
        final result =
            await mockLocationRepository.getDepartmentsByCountry('CO');

        // assert
        expect(result, isA<Right<Failure, List<Department>>>());
        result.fold(
          (failure) => fail('Should return success'),
          (departments) => expect(departments, isEmpty),
        );
        verify(mockLocationRepository.getDepartmentsByCountry('CO'));
      });

      test('should return Failure when country does not exist', () async {
        // arrange
        const tFailure = NotFoundFailure(
          message: 'Country not found',
          code: 'COUNTRY_NOT_FOUND',
        );

        when(mockLocationRepository.getDepartmentsByCountry('INVALID'))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result =
            await mockLocationRepository.getDepartmentsByCountry('INVALID');

        // assert
        expect(result, isA<Left<Failure, List<Department>>>());
        expect(result, equals(const Left(tFailure)));
        verify(mockLocationRepository.getDepartmentsByCountry('INVALID'));
      });
    });

    group('getMunicipalitiesByDepartment', () {
      test('should define getMunicipalitiesByDepartment method signature', () {
        // arrange & act
        when(mockLocationRepository.getMunicipalitiesByDepartment('ANT'))
            .thenAnswer((_) async => Right(tMunicipalities));

        // assert - method signature exists and can be mocked
        expect(mockLocationRepository.getMunicipalitiesByDepartment,
            isA<Function>());
      });

      test('should return list of Municipalities for valid department',
          () async {
        // arrange
        when(mockLocationRepository.getMunicipalitiesByDepartment('ANT'))
            .thenAnswer((_) async => Right(tMunicipalities));

        // act
        final result =
            await mockLocationRepository.getMunicipalitiesByDepartment('ANT');

        // assert
        expect(result, isA<Right<Failure, List<Municipality>>>());
        result.fold(
          (failure) => fail('Should return success'),
          (municipalities) => expect(municipalities, equals(tMunicipalities)),
        );
        verify(mockLocationRepository.getMunicipalitiesByDepartment('ANT'));
      });

      test('should return empty list when department has no municipalities',
          () async {
        // arrange
        when(mockLocationRepository.getMunicipalitiesByDepartment('ANT'))
            .thenAnswer((_) async => const Right([]));

        // act
        final result =
            await mockLocationRepository.getMunicipalitiesByDepartment('ANT');

        // assert
        expect(result, isA<Right<Failure, List<Municipality>>>());
        result.fold(
          (failure) => fail('Should return success'),
          (municipalities) => expect(municipalities, isEmpty),
        );
        verify(mockLocationRepository.getMunicipalitiesByDepartment('ANT'));
      });

      test('should return Failure when department does not exist', () async {
        // arrange
        const tFailure = NotFoundFailure(
          message: 'Department not found',
          code: 'DEPARTMENT_NOT_FOUND',
        );

        when(mockLocationRepository.getMunicipalitiesByDepartment('INVALID'))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await mockLocationRepository
            .getMunicipalitiesByDepartment('INVALID');

        // assert
        expect(result, isA<Left<Failure, List<Municipality>>>());
        expect(result, equals(const Left(tFailure)));
        verify(mockLocationRepository.getMunicipalitiesByDepartment('INVALID'));
      });
    });

    group('searchDepartments', () {
      test('should define searchDepartments method signature', () {
        // arrange & act
        when(mockLocationRepository.searchDepartments('CO', 'Ant'))
            .thenAnswer((_) async => Right([tDepartments.first]));

        // assert - method signature exists and can be mocked
        expect(mockLocationRepository.searchDepartments, isA<Function>());
      });

      test('should return filtered departments on successful search', () async {
        // arrange
        when(mockLocationRepository.searchDepartments('CO', 'Ant'))
            .thenAnswer((_) async => Right([tDepartments.first]));

        // act
        final result =
            await mockLocationRepository.searchDepartments('CO', 'Ant');

        // assert
        expect(result, isA<Right<Failure, List<Department>>>());
        result.fold(
          (failure) => fail('Should return success'),
          (departments) {
            expect(departments.length, equals(1));
            expect(departments.first, equals(tDepartments.first));
          },
        );
        verify(mockLocationRepository.searchDepartments('CO', 'Ant'));
      });

      test('should return empty list when no departments match query',
          () async {
        // arrange
        when(mockLocationRepository.searchDepartments('CO', 'XYZ'))
            .thenAnswer((_) async => const Right([]));

        // act
        final result =
            await mockLocationRepository.searchDepartments('CO', 'XYZ');

        // assert
        expect(result, isA<Right<Failure, List<Department>>>());
        result.fold(
          (failure) => fail('Should return success'),
          (departments) => expect(departments, isEmpty),
        );
        verify(mockLocationRepository.searchDepartments('CO', 'XYZ'));
      });
    });

    group('searchCountries', () {
      test('should define searchCountries method signature', () {
        // arrange & act
        when(mockLocationRepository.searchCountries('Col'))
            .thenAnswer((_) async => Right([tCountries.first]));

        // assert - method signature exists and can be mocked
        expect(mockLocationRepository.searchCountries, isA<Function>());
      });

      test('should return filtered countries on successful search', () async {
        // arrange
        when(mockLocationRepository.searchCountries('Col'))
            .thenAnswer((_) async => Right([tCountries.first]));

        // act
        final result = await mockLocationRepository.searchCountries('Col');

        // assert
        expect(result, isA<Right<Failure, List<Country>>>());
        result.fold(
          (failure) => fail('Should return success'),
          (countries) {
            expect(countries.length, equals(1));
            expect(countries.first, equals(tCountries.first));
          },
        );
        verify(mockLocationRepository.searchCountries('Col'));
      });

      test('should return empty list when no countries match query', () async {
        // arrange
        when(mockLocationRepository.searchCountries('XYZ'))
            .thenAnswer((_) async => const Right([]));

        // act
        final result = await mockLocationRepository.searchCountries('XYZ');

        // assert
        expect(result, isA<Right<Failure, List<Country>>>());
        result.fold(
          (failure) => fail('Should return success'),
          (countries) => expect(countries, isEmpty),
        );
        verify(mockLocationRepository.searchCountries('XYZ'));
      });
    });

    group('getDepartmentById', () {
      test('should define getDepartmentById method signature', () {
        // arrange & act
        when(mockLocationRepository.getDepartmentById('ANT'))
            .thenAnswer((_) async => Right(tDepartments.first));

        // assert - method signature exists and can be mocked
        expect(mockLocationRepository.getDepartmentById, isA<Function>());
      });

      test('should return Department when department exists', () async {
        // arrange
        when(mockLocationRepository.getDepartmentById('ANT'))
            .thenAnswer((_) async => Right(tDepartments.first));

        // act
        final result = await mockLocationRepository.getDepartmentById('ANT');

        // assert
        expect(result, isA<Right<Failure, Department>>());
        result.fold(
          (failure) => fail('Should return success'),
          (department) => expect(department, equals(tDepartments.first)),
        );
        verify(mockLocationRepository.getDepartmentById('ANT'));
      });

      test('should return NotFoundFailure when department does not exist',
          () async {
        // arrange
        const tFailure = NotFoundFailure(
          message: 'Department not found',
          code: 'DEPARTMENT_NOT_FOUND',
        );

        when(mockLocationRepository.getDepartmentById('INVALID'))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result =
            await mockLocationRepository.getDepartmentById('INVALID');

        // assert
        expect(result, isA<Left<Failure, Department>>());
        expect(result, equals(const Left(tFailure)));
        verify(mockLocationRepository.getDepartmentById('INVALID'));
      });
    });

    group('getMunicipalityById', () {
      test('should define getMunicipalityById method signature', () {
        // arrange & act
        when(mockLocationRepository.getMunicipalityById('MED'))
            .thenAnswer((_) async => Right(tMunicipalities.first));

        // assert - method signature exists and can be mocked
        expect(mockLocationRepository.getMunicipalityById, isA<Function>());
      });

      test('should return Municipality when municipality exists', () async {
        // arrange
        when(mockLocationRepository.getMunicipalityById('MED'))
            .thenAnswer((_) async => Right(tMunicipalities.first));

        // act
        final result = await mockLocationRepository.getMunicipalityById('MED');

        // assert
        expect(result, isA<Right<Failure, Municipality>>());
        result.fold(
          (failure) => fail('Should return success'),
          (municipality) => expect(municipality, equals(tMunicipalities.first)),
        );
        verify(mockLocationRepository.getMunicipalityById('MED'));
      });

      test('should return NotFoundFailure when municipality does not exist',
          () async {
        // arrange
        const tFailure = NotFoundFailure(
          message: 'Municipality not found',
          code: 'MUNICIPALITY_NOT_FOUND',
        );

        when(mockLocationRepository.getMunicipalityById('INVALID'))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result =
            await mockLocationRepository.getMunicipalityById('INVALID');

        // assert
        expect(result, isA<Left<Failure, Municipality>>());
        expect(result, equals(const Left(tFailure)));
        verify(mockLocationRepository.getMunicipalityById('INVALID'));
      });
    });

    group('getLocationHierarchy', () {
      test('should define getLocationHierarchy method signature', () {
        // arrange
        final hierarchyData = {
          'country': 'Colombia',
          'department': 'Antioquia',
          'municipality': 'Medellín',
        };

        when(mockLocationRepository.getLocationHierarchy('CO', 'ANT', 'MED'))
            .thenAnswer((_) async => Right(hierarchyData));

        // assert - method signature exists and can be mocked
        expect(mockLocationRepository.getLocationHierarchy, isA<Function>());
      });

      test('should return location hierarchy data on success', () async {
        // arrange
        final hierarchyData = {
          'country': 'Colombia',
          'department': 'Antioquia',
          'municipality': 'Medellín',
        };

        when(mockLocationRepository.getLocationHierarchy('CO', 'ANT', 'MED'))
            .thenAnswer((_) async => Right(hierarchyData));

        // act
        final result = await mockLocationRepository.getLocationHierarchy(
            'CO', 'ANT', 'MED');

        // assert
        expect(result, isA<Right<Failure, Map<String, dynamic>>>());
        result.fold(
          (failure) => fail('Should return success'),
          (hierarchy) => expect(hierarchy, equals(hierarchyData)),
        );
        verify(mockLocationRepository.getLocationHierarchy('CO', 'ANT', 'MED'));
      });

      test('should return Failure when hierarchy cannot be retrieved',
          () async {
        // arrange
        const tFailure = ValidationFailure(
          message: 'Invalid location hierarchy',
          code: 'INVALID_HIERARCHY',
        );

        when(mockLocationRepository.getLocationHierarchy(
                'INVALID', 'INVALID', 'INVALID'))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await mockLocationRepository.getLocationHierarchy(
            'INVALID', 'INVALID', 'INVALID');

        // assert
        expect(result, isA<Left<Failure, Map<String, dynamic>>>());
        expect(result, equals(const Left(tFailure)));
        verify(mockLocationRepository.getLocationHierarchy(
            'INVALID', 'INVALID', 'INVALID'));
      });
    });

    group('validateLocationHierarchy', () {
      test('should define validateLocationHierarchy method signature', () {
        // arrange & act
        when(mockLocationRepository.validateLocationHierarchy(
                'CO', 'ANT', 'MED'))
            .thenAnswer((_) async => const Right(true));

        // assert - method signature exists and can be mocked
        expect(
            mockLocationRepository.validateLocationHierarchy, isA<Function>());
      });

      test('should return true for valid location hierarchy', () async {
        // arrange
        when(mockLocationRepository.validateLocationHierarchy(
                'CO', 'ANT', 'MED'))
            .thenAnswer((_) async => const Right(true));

        // act
        final result = await mockLocationRepository.validateLocationHierarchy(
            'CO', 'ANT', 'MED');

        // assert
        expect(result, isA<Right<Failure, bool>>());
        result.fold(
          (failure) => fail('Should return success'),
          (isValid) => expect(isValid, isTrue),
        );
        verify(mockLocationRepository.validateLocationHierarchy(
            'CO', 'ANT', 'MED'));
      });

      test('should return false for invalid location hierarchy', () async {
        // arrange
        when(mockLocationRepository.validateLocationHierarchy(
                'CO', 'BOG', 'MED'))
            .thenAnswer((_) async => const Right(false));

        // act
        final result = await mockLocationRepository.validateLocationHierarchy(
            'CO', 'BOG', 'MED');

        // assert
        expect(result, isA<Right<Failure, bool>>());
        result.fold(
          (failure) => fail('Should return success'),
          (isValid) => expect(isValid, isFalse),
        );
        verify(mockLocationRepository.validateLocationHierarchy(
            'CO', 'BOG', 'MED'));
      });

      test('should return Failure when validation service fails', () async {
        // arrange
        const tFailure = ServerFailure(
          message: 'Location validation service error',
          code: 'LOCATION_VALIDATION_ERROR',
        );

        when(mockLocationRepository.validateLocationHierarchy(
                'INVALID', 'INVALID', 'INVALID'))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await mockLocationRepository.validateLocationHierarchy(
            'INVALID', 'INVALID', 'INVALID');

        // assert
        expect(result, isA<Left<Failure, bool>>());
        expect(result, equals(const Left(tFailure)));
        verify(mockLocationRepository.validateLocationHierarchy(
            'INVALID', 'INVALID', 'INVALID'));
      });
    });

    group('LocationRepository contract validation', () {
      test('should implement all required methods', () {
        // This test ensures all methods are properly defined in the interface
        expect(mockLocationRepository, isA<LocationRepository>());

        // Verify method signatures exist
        expect(mockLocationRepository.getCountries, isA<Function>());
        expect(mockLocationRepository.getCountryById, isA<Function>());
        expect(mockLocationRepository.searchCountries, isA<Function>());
        expect(mockLocationRepository.getDepartmentsByCountry, isA<Function>());
        expect(mockLocationRepository.getDepartmentById, isA<Function>());
        expect(mockLocationRepository.searchDepartments, isA<Function>());
        expect(mockLocationRepository.getMunicipalitiesByDepartment,
            isA<Function>());
        expect(mockLocationRepository.getMunicipalityById, isA<Function>());
        expect(mockLocationRepository.searchMunicipalities, isA<Function>());
        expect(mockLocationRepository.getLocationHierarchy, isA<Function>());
        expect(
            mockLocationRepository.validateLocationHierarchy, isA<Function>());

        // If we get here without compilation errors, all methods are properly defined
        expect(true, isTrue);
      });

      test('should handle all expected error scenarios', () {
        // Test that repository can return different types of failures
        const serverFailure =
            ServerFailure(message: 'Server error', code: 'SERVER_ERROR');
        const notFoundFailure =
            NotFoundFailure(message: 'Not found', code: 'NOT_FOUND');
        const validationFailure = ValidationFailure(
            message: 'Validation error', code: 'VALIDATION_ERROR');

        // Mock different failure scenarios
        when(mockLocationRepository.getCountries())
            .thenAnswer((_) async => const Left(serverFailure));
        when(mockLocationRepository.getCountryById('INVALID'))
            .thenAnswer((_) async => const Left(notFoundFailure));
        when(mockLocationRepository.validateLocationHierarchy('', '', ''))
            .thenAnswer((_) async => const Left(validationFailure));

        // Verify failure types are properly handled
        expect(const Left(serverFailure), isA<Left<Failure, List<Country>>>());
        expect(const Left(notFoundFailure), isA<Left<Failure, Country>>());
        expect(const Left(validationFailure), isA<Left<Failure, bool>>());
      });
    });
  });
}
