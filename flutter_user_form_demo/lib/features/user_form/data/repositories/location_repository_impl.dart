import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/department.dart';
import '../../domain/entities/municipality.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/local/location_local_data_source.dart';
import '../datasources/remote/location_remote_data_source.dart';
import '../models/country_model.dart';
import '../models/department_model.dart';
import '../models/municipality_model.dart';

/// Implementation of LocationRepository using local and remote data sources
@LazySingleton(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource localDataSource;
  final LocationRemoteDataSource remoteDataSource;

  const LocationRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Country>>> getCountries() async {
    try {
      // First try to get from local cache
      final localCountries = await localDataSource.getCountries();
      if (localCountries.isNotEmpty) {
        final countries = localCountries
            .cast<CountryModel>()
            .map((model) => model.toEntity())
            .toList();
        return Right(countries);
      }

      // If not in cache, fetch from remote
      final remoteCountries = await remoteDataSource.getCountries();

      // Cache the results locally
      await localDataSource.cacheCountries(remoteCountries);

      final countries = remoteCountries
          .cast<CountryModel>()
          .map((model) => model.toEntity())
          .toList();
      return Right(countries);
    } catch (e) {
      return Left(
          CacheFailure(message: 'Failed to get countries: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Country>> getCountryById(String countryId) async {
    try {
      final model = await localDataSource.getCountryById(countryId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(CacheFailure(
          message: 'Failed to get country by id: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Country>>> searchCountries(String query) async {
    try {
      final models = await localDataSource.searchCountries(query);
      final countries = models
          .whereType<CountryModel>()
          .map((model) => model.toEntity())
          .toList();
      return Right(countries);
    } catch (e) {
      return Left(
          CacheFailure(message: 'Failed to search countries: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Department>>> getDepartmentsByCountry(
      String countryId) async {
    try {
      // First try to get from local cache
      final localDepartments =
          await localDataSource.getDepartmentsByCountry(countryId);
      if (localDepartments.isNotEmpty) {
        final departments = localDepartments
            .whereType<DepartmentModel>()
            .map((model) => model.toEntity())
            .toList();
        return Right(departments);
      }

      // If not in cache, fetch from remote
      final remoteDepartments =
          await remoteDataSource.getDepartmentsByCountry(countryId);

      // Cache the results locally
      await localDataSource.cacheDepartments(remoteDepartments);

      final departments = remoteDepartments
          .whereType<DepartmentModel>()
          .map((model) => model.toEntity())
          .toList();
      return Right(departments);
    } catch (e) {
      return Left(
          CacheFailure(message: 'Failed to get departments: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Department>> getDepartmentById(
      String departmentId) async {
    try {
      final model = await localDataSource.getDepartmentById(departmentId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(CacheFailure(
          message: 'Failed to get department by id: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Department>>> searchDepartments(
      String countryId, String query) async {
    try {
      final models = await localDataSource.searchDepartments(countryId, query);
      final departments = models
          .whereType<DepartmentModel>()
          .map((model) => model.toEntity())
          .toList();
      return Right(departments);
    } catch (e) {
      return Left(CacheFailure(
          message: 'Failed to search departments: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Municipality>>> getMunicipalitiesByDepartment(
      String departmentId) async {
    try {
      // First try to get from local cache
      final localMunicipalities =
          await localDataSource.getMunicipalitiesByDepartment(departmentId);
      if (localMunicipalities.isNotEmpty) {
        final municipalities = localMunicipalities
            .whereType<MunicipalityModel>()
            .map((model) => model.toEntity())
            .toList();
        return Right(municipalities);
      }

      // If not in cache, fetch from remote
      final remoteMunicipalities =
          await remoteDataSource.getMunicipalitiesByDepartment(departmentId);

      // Cache the results locally
      await localDataSource.cacheMunicipalities(remoteMunicipalities);

      final municipalities = remoteMunicipalities
          .whereType<MunicipalityModel>()
          .map((model) => model.toEntity())
          .toList();
      return Right(municipalities);
    } catch (e) {
      return Left(CacheFailure(
          message: 'Failed to get municipalities: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Municipality>> getMunicipalityById(
      String municipalityId) async {
    try {
      final model = await localDataSource.getMunicipalityById(municipalityId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(CacheFailure(
          message: 'Failed to get municipality by id: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Municipality>>> searchMunicipalities(
      String departmentId, String query) async {
    try {
      final models =
          await localDataSource.searchMunicipalities(departmentId, query);
      final municipalities = models
          .whereType<MunicipalityModel>()
          .map((model) => model.toEntity())
          .toList();
      return Right(municipalities);
    } catch (e) {
      return Left(CacheFailure(
          message: 'Failed to search municipalities: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getLocationHierarchy(
    String countryId,
    String departmentId,
    String municipalityId,
  ) async {
    try {
      final country = await localDataSource.getCountryById(countryId);
      final department = await localDataSource.getDepartmentById(departmentId);
      final municipality =
          await localDataSource.getMunicipalityById(municipalityId);

      return Right({
        'country': country.toEntity(),
        'department': department.toEntity(),
        'municipality': municipality.toEntity(),
      });
    } catch (e) {
      return Left(CacheFailure(
          message: 'Failed to get location hierarchy: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> validateLocationHierarchy(
    String countryId,
    String departmentId,
    String municipalityId,
  ) async {
    try {
      // Check if department belongs to country
      final department = await localDataSource.getDepartmentById(departmentId);
      if (department.countryId != countryId) {
        return Right(false);
      }

      // Check if municipality belongs to department
      final municipality =
          await localDataSource.getMunicipalityById(municipalityId);
      if (municipality.departmentId != departmentId) {
        return Right(false);
      }

      return Right(true);
    } catch (e) {
      return Left(CacheFailure(
          message: 'Failed to validate location hierarchy: ${e.toString()}'));
    }
  }
}
