import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/country.dart';
import '../repositories/location_repository.dart';

class GetCountriesUseCase implements NoParamsUseCase<List<Country>> {
  final LocationRepository repository;

  const GetCountriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Country>>> call() async {
    final result = await repository.getCountries();

    return result.fold(
      (failure) => Left(failure),
      (countries) {
        final activeCountries = countries
            .where((country) => country.isActive)
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));

        return Right(activeCountries);
      },
    );
  }
}

class SearchCountriesUseCase
    implements UseCase<List<Country>, SearchCountriesParams> {
  final LocationRepository repository;

  const SearchCountriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Country>>> call(
      SearchCountriesParams params) async {
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

    final result = await repository.searchCountries(params.query);

    return result.fold(
      (failure) => Left(failure),
      (countries) {
        final activeCountries =
            countries.where((country) => country.isActive).toList();

        activeCountries.sort((a, b) {
          final aExactMatch =
              a.name.toLowerCase() == params.query.toLowerCase();
          final bExactMatch =
              b.name.toLowerCase() == params.query.toLowerCase();

          if (aExactMatch && !bExactMatch) return -1;
          if (!aExactMatch && bExactMatch) return 1;

          return a.name.compareTo(b.name);
        });

        return Right(activeCountries);
      },
    );
  }
}

class SearchCountriesParams extends UseCaseParams {
  final String query;

  const SearchCountriesParams({required this.query});

  @override
  List<Object> get props => [query];
}
