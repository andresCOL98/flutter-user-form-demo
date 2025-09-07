import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_user_form_demo/core/errors/failures.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/municipality.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/usecases/get_municipalities_usecase.dart';

import '../../../../helpers/test_mocks.dart';

void main() {
  group('GetMunicipalitiesUseCase', () {
    late GetMunicipalitiesUseCase useCase;
    late MockLocationRepository mockLocationRepository;

    setUp(() {
      mockLocationRepository = MockLocationRepository();
      useCase = GetMunicipalitiesUseCase(mockLocationRepository);
    });

    tearDown(() {
      reset(mockLocationRepository);
    });

    const tDepartmentId = 'ANT';

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

    test(
        'should return list of municipalities when repository call is successful',
        () async {
      when(mockLocationRepository.getMunicipalitiesByDepartment(tDepartmentId))
          .thenAnswer((_) async => Right(tMunicipalities));

      final params = GetMunicipalitiesParams(departmentId: tDepartmentId);

      final result = await useCase(params);

      expect(result, equals(Right(tMunicipalities)));
      verify(
          mockLocationRepository.getMunicipalitiesByDepartment(tDepartmentId));
      verifyNoMoreInteractions(mockLocationRepository);
    });

    test('should return ValidationFailure when departmentId is empty',
        () async {
      final params = GetMunicipalitiesParams(departmentId: '');

      final result = await useCase(params);

      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('Department ID'));
          expect(failure.code, contains('EMPTY'));
        },
        (municipalities) => fail('Should return failure'),
      );
      verifyZeroInteractions(mockLocationRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      const tServerFailure = ServerFailure(
        message: 'Failed to load municipalities',
        code: 'MUNICIPALITIES_LOAD_ERROR',
      );

      when(mockLocationRepository.getMunicipalitiesByDepartment(tDepartmentId))
          .thenAnswer((_) async => const Left(tServerFailure));

      final params = GetMunicipalitiesParams(departmentId: tDepartmentId);

      final result = await useCase(params);

      expect(result, equals(const Left(tServerFailure)));
      verify(
          mockLocationRepository.getMunicipalitiesByDepartment(tDepartmentId));
      verifyNoMoreInteractions(mockLocationRepository);
    });

    test('should handle empty municipalities list from repository', () async {
      when(mockLocationRepository.getMunicipalitiesByDepartment(tDepartmentId))
          .thenAnswer((_) async => const Right([]));

      final params = GetMunicipalitiesParams(departmentId: tDepartmentId);

      final result = await useCase(params);

      expect(result, equals(const Right([])));
      verify(
          mockLocationRepository.getMunicipalitiesByDepartment(tDepartmentId));
      verifyNoMoreInteractions(mockLocationRepository);
    });
  });
}
