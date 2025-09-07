import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_user_form_demo/core/errors/failures.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/department.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/municipality.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/repositories/location_repository.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/usecases/get_departments_usecase.dart';

class MockLocationRepository extends Mock implements LocationRepository {
  @override
  Future<Either<Failure, List<Department>>> getDepartmentsByCountry(
          String countryId) =>
      (super.noSuchMethod(
        Invocation.method(#getDepartmentsByCountry, [countryId]),
        returnValue: Future<Either<Failure, List<Department>>>.value(
            Right(<Department>[])),
      ) as Future<Either<Failure, List<Department>>>);

  @override
  Future<Either<Failure, List<Municipality>>> getMunicipalitiesByDepartment(
          String departmentId) =>
      (super.noSuchMethod(
        Invocation.method(#getMunicipalitiesByDepartment, [departmentId]),
        returnValue: Future<Either<Failure, List<Municipality>>>.value(
            Right(<Municipality>[])),
      ) as Future<Either<Failure, List<Municipality>>>);
}

void main() {
  group('GetDepartmentsUseCase - Simple Test', () {
    late GetDepartmentsUseCase useCase;
    late MockLocationRepository mockLocationRepository;

    setUp(() {
      mockLocationRepository = MockLocationRepository();
      useCase = GetDepartmentsUseCase(mockLocationRepository);
    });

    test('should return list of departments when repository call is successful',
        () async {
      // arrange
      const tCountryId = 'CO';
      final tDepartments = [
        const Department(
          id: 'ANT',
          name: 'Antioquia',
          countryId: 'CO',
          code: '05',
        ),
      ];

      when(mockLocationRepository.getDepartmentsByCountry(tCountryId))
          .thenAnswer((_) async => Right(tDepartments));

      final params = GetDepartmentsParams(countryId: tCountryId);

      // act
      final result = await useCase(params);

      // assert
      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Should return success'),
        (departments) {
          expect(departments, equals(tDepartments));
        },
      );

      verify(mockLocationRepository.getDepartmentsByCountry(tCountryId));
    });
  });
}
