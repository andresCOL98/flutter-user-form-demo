import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/country.dart';
import '../entities/department.dart';
import '../entities/municipality.dart';

abstract class LocationRepository {
  Future<Either<Failure, List<Country>>> getCountries();
  Future<Either<Failure, Country>> getCountryById(String countryId);
  Future<Either<Failure, List<Country>>> searchCountries(String query);
  Future<Either<Failure, List<Department>>> getDepartmentsByCountry(
      String countryId);
  Future<Either<Failure, Department>> getDepartmentById(String departmentId);
  Future<Either<Failure, List<Department>>> searchDepartments(
    String countryId,
    String query,
  );
  Future<Either<Failure, List<Municipality>>> getMunicipalitiesByDepartment(
    String departmentId,
  );
  Future<Either<Failure, Municipality>> getMunicipalityById(
      String municipalityId);
  Future<Either<Failure, List<Municipality>>> searchMunicipalities(
    String departmentId,
    String query,
  );
  Future<Either<Failure, Map<String, dynamic>>> getLocationHierarchy(
    String countryId,
    String departmentId,
    String municipalityId,
  );
  Future<Either<Failure, bool>> validateLocationHierarchy(
    String countryId,
    String departmentId,
    String municipalityId,
  );
}
