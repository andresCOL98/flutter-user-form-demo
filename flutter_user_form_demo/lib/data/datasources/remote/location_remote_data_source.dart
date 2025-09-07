import 'package:injectable/injectable.dart';

import '../../models/country_model.dart';
import '../../models/department_model.dart';
import '../../models/municipality_model.dart';

/// Abstract interface for location remote data source
abstract class LocationRemoteDataSource {
  Future<List<CountryModel>> getCountries();
  Future<CountryModel> getCountryById(String id);
  Future<List<CountryModel>> searchCountries(String query);
  Future<List<DepartmentModel>> getDepartmentsByCountry(String countryId);
  Future<DepartmentModel> getDepartmentById(String id);
  Future<List<DepartmentModel>> searchDepartments(
      String countryId, String query);
  Future<List<MunicipalityModel>> getMunicipalitiesByDepartment(
      String departmentId);
  Future<MunicipalityModel> getMunicipalityById(String id);
  Future<List<MunicipalityModel>> searchMunicipalities(
      String departmentId, String query);
}

/// Mock implementation of LocationRemoteDataSource
/// In production, this would make HTTP requests to external APIs
@LazySingleton(as: LocationRemoteDataSource)
class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  @override
  Future<List<CountryModel>> getCountries() async {
    // Mock implementation - in production this would call external API
    // For now, return empty list since we're using pre-seeded local data
    return [];
  }

  @override
  Future<CountryModel> getCountryById(String id) async {
    throw Exception('Remote data source: Country with id $id not found');
  }

  @override
  Future<List<CountryModel>> searchCountries(String query) async {
    return [];
  }

  @override
  Future<List<DepartmentModel>> getDepartmentsByCountry(
      String countryId) async {
    return [];
  }

  @override
  Future<DepartmentModel> getDepartmentById(String id) async {
    throw Exception('Remote data source: Department with id $id not found');
  }

  @override
  Future<List<DepartmentModel>> searchDepartments(
      String countryId, String query) async {
    return [];
  }

  @override
  Future<List<MunicipalityModel>> getMunicipalitiesByDepartment(
      String departmentId) async {
    return [];
  }

  @override
  Future<MunicipalityModel> getMunicipalityById(String id) async {
    throw Exception('Remote data source: Municipality with id $id not found');
  }

  @override
  Future<List<MunicipalityModel>> searchMunicipalities(
      String departmentId, String query) async {
    return [];
  }
}
