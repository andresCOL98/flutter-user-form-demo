import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/department.dart';
import '../repositories/location_repository.dart';

class GetDepartmentsUseCase
    implements UseCase<List<Department>, GetDepartmentsParams> {
  final LocationRepository repository;

  const GetDepartmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Department>>> call(
      GetDepartmentsParams params) async {
    if (params.countryId.isEmpty) {
      return const Left(
        ValidationFailure(
          message: 'Country ID cannot be empty',
          code: 'EMPTY_COUNTRY_ID',
        ),
      );
    }

    final result = await repository.getDepartmentsByCountry(params.countryId);

    return result.fold(
      (failure) => Left(failure),
      (departments) {
        final activeDepartments = departments
            .where((department) => department.isActive)
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));

        return Right(activeDepartments);
      },
    );
  }
}

class SearchDepartmentsUseCase
    implements UseCase<List<Department>, SearchDepartmentsParams> {
  final LocationRepository repository;

  const SearchDepartmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Department>>> call(
      SearchDepartmentsParams params) async {
    if (params.countryId.isEmpty) {
      return const Left(
        ValidationFailure(
          message: 'Country ID cannot be empty',
          code: 'EMPTY_COUNTRY_ID',
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

    final result =
        await repository.searchDepartments(params.countryId, params.query);

    return result.fold(
      (failure) => Left(failure),
      (departments) {
        final activeDepartments =
            departments.where((department) => department.isActive).toList();

        activeDepartments.sort((a, b) {
          final aExactMatch =
              a.name.toLowerCase() == params.query.toLowerCase();
          final bExactMatch =
              b.name.toLowerCase() == params.query.toLowerCase();

          if (aExactMatch && !bExactMatch) return -1;
          if (!aExactMatch && bExactMatch) return 1;

          return a.name.compareTo(b.name);
        });

        return Right(activeDepartments);
      },
    );
  }
}

class GetDepartmentsParams extends UseCaseParams {
  final String countryId;

  const GetDepartmentsParams({required this.countryId});

  @override
  List<Object> get props => [countryId];
}

class SearchDepartmentsParams extends UseCaseParams {
  final String countryId;
  final String query;

  const SearchDepartmentsParams({
    required this.countryId,
    required this.query,
  });

  @override
  List<Object> get props => [countryId, query];
}
