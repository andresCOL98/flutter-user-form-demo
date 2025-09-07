import 'package:injectable/injectable.dart';

import '../../models/country_model.dart';
import '../../models/department_model.dart';
import '../../models/municipality_model.dart';

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

@LazySingleton(as: LocationRemoteDataSource)
class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  @override
  Future<List<CountryModel>> getCountries() async {
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
