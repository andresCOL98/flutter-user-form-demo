import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/municipality.dart';
import '../repositories/location_repository.dart';

class GetMunicipalitiesUseCase
    implements UseCase<List<Municipality>, GetMunicipalitiesParams> {
  final LocationRepository repository;

  const GetMunicipalitiesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Municipality>>> call(
      GetMunicipalitiesParams params) async {
    if (params.departmentId.isEmpty) {
      return const Left(
        ValidationFailure(
          message: 'Department ID cannot be empty',
          code: 'EMPTY_DEPARTMENT_ID',
        ),
      );
    }

    final result =
        await repository.getMunicipalitiesByDepartment(params.departmentId);

    return result.fold(
      (failure) => Left(failure),
      (municipalities) {
        final activeMunicipalities = municipalities
            .where((municipality) => municipality.isActive)
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));

        return Right(activeMunicipalities);
      },
    );
  }
}

class SearchMunicipalitiesUseCase
    implements UseCase<List<Municipality>, SearchMunicipalitiesParams> {
  final LocationRepository repository;

  const SearchMunicipalitiesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Municipality>>> call(
      SearchMunicipalitiesParams params) async {
    if (params.departmentId.isEmpty) {
      return const Left(
        ValidationFailure(
          message: 'Department ID cannot be empty',
          code: 'EMPTY_DEPARTMENT_ID',
        ),
      );
    }

    if (params.query.isEmpty) {
      return const Left(
        ValidationFailure(
          message: 'Search query cannot be empty',
          code: 'EMPTY_SEARCH_QUERY',
        ),
      );
    }

    if (params.query.length < 2) {
      return const Left(
        ValidationFailure(
          message: 'Search query must be at least 2 characters long',
          code: 'SHORT_SEARCH_QUERY',
        ),
      );
    }

    final result = await repository.searchMunicipalities(
        params.departmentId, params.query);

    return result.fold(
      (failure) => Left(failure),
      (municipalities) {
        final activeMunicipalities = municipalities
            .where((municipality) => municipality.isActive)
            .toList();

        activeMunicipalities.sort((a, b) {
          final aExactMatch =
              a.name.toLowerCase() == params.query.toLowerCase();
          final bExactMatch =
              b.name.toLowerCase() == params.query.toLowerCase();

          if (aExactMatch && !bExactMatch) return -1;
          if (!aExactMatch && bExactMatch) return 1;

          return a.name.compareTo(b.name);
        });

        return Right(activeMunicipalities);
      },
    );
  }
}

class GetMunicipalitiesParams extends UseCaseParams {
  final String departmentId;

  const GetMunicipalitiesParams({required this.departmentId});

  @override
  List<Object> get props => [departmentId];
}

class SearchMunicipalitiesParams extends UseCaseParams {
  final String departmentId;
  final String query;

  const SearchMunicipalitiesParams({
    required this.departmentId,
    required this.query,
  });

  @override
  List<Object> get props => [departmentId, query];
}
