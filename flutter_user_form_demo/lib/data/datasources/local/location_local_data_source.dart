import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/country_model.dart';
import '../../models/department_model.dart';
import '../../models/municipality_model.dart';
import 'database_constants.dart';

/// Abstract interface for location local data source
abstract class LocationLocalDataSource {
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
  Future<void> cacheCountries(List<CountryModel> countries);
  Future<void> cacheDepartments(List<DepartmentModel> departments);
  Future<void> cacheMunicipalities(List<MunicipalityModel> municipalities);
}

/// Implementation of LocationLocalDataSource using SQLite database
@LazySingleton(as: LocationLocalDataSource)
class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final Future<Database> _database;

  LocationLocalDataSourceImpl() : _database = _initializeDatabase();

  static Future<Database> _initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, DatabaseConstants.databaseName);
    return await openDatabase(path);
  }

  Future<Database> get database => _database;

  @override
  Future<List<CountryModel>> getCountries() async {
    final db = await database;
    final maps = await db.query(
      DatabaseConstants.tableCountries,
      where: '${DatabaseConstants.countryIsActive} = ?',
      whereArgs: [1],
      orderBy: DatabaseConstants.countryName,
    );

    return maps.map((map) => CountryModel.fromMap(map)).toList();
  }

  @override
  Future<CountryModel> getCountryById(String id) async {
    final db = await database;
    final maps = await db.query(
      DatabaseConstants.tableCountries,
      where: '${DatabaseConstants.countryId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      throw Exception('Country with id $id not found');
    }

    return CountryModel.fromMap(maps.first);
  }

  @override
  Future<List<CountryModel>> searchCountries(String query) async {
    final db = await database;
    final maps = await db.query(
      DatabaseConstants.tableCountries,
      where: '''
        ${DatabaseConstants.countryIsActive} = ? AND (
          ${DatabaseConstants.countryName} LIKE ? OR 
          ${DatabaseConstants.countryCode} LIKE ?
        )
      ''',
      whereArgs: [1, '%$query%', '%$query%'],
      orderBy: DatabaseConstants.countryName,
    );

    return maps.map((map) => CountryModel.fromMap(map)).toList();
  }

  @override
  Future<List<DepartmentModel>> getDepartmentsByCountry(
      String countryId) async {
    final db = await database;
    final maps = await db.query(
      DatabaseConstants.tableDepartments,
      where: '''
        ${DatabaseConstants.departmentCountryId} = ? AND 
        ${DatabaseConstants.departmentIsActive} = ?
      ''',
      whereArgs: [countryId, 1],
      orderBy: DatabaseConstants.departmentName,
    );

    return maps.map((map) => DepartmentModel.fromMap(map)).toList();
  }

  @override
  Future<DepartmentModel> getDepartmentById(String id) async {
    final db = await database;
    final maps = await db.query(
      DatabaseConstants.tableDepartments,
      where: '${DatabaseConstants.departmentId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      throw Exception('Department with id $id not found');
    }

    return DepartmentModel.fromMap(maps.first);
  }

  @override
  Future<List<DepartmentModel>> searchDepartments(
      String countryId, String query) async {
    final db = await database;
    final maps = await db.query(
      DatabaseConstants.tableDepartments,
      where: '''
        ${DatabaseConstants.departmentCountryId} = ? AND 
        ${DatabaseConstants.departmentIsActive} = ? AND (
          ${DatabaseConstants.departmentName} LIKE ? OR 
          ${DatabaseConstants.departmentCode} LIKE ?
        )
      ''',
      whereArgs: [countryId, 1, '%$query%', '%$query%'],
      orderBy: DatabaseConstants.departmentName,
    );

    return maps.map((map) => DepartmentModel.fromMap(map)).toList();
  }

  @override
  Future<List<MunicipalityModel>> getMunicipalitiesByDepartment(
      String departmentId) async {
    final db = await database;
    final maps = await db.query(
      DatabaseConstants.tableMunicipalities,
      where: '''
        ${DatabaseConstants.municipalityDepartmentId} = ? AND 
        ${DatabaseConstants.municipalityIsActive} = ?
      ''',
      whereArgs: [departmentId, 1],
      orderBy: DatabaseConstants.municipalityName,
    );

    return maps.map((map) => MunicipalityModel.fromMap(map)).toList();
  }

  @override
  Future<MunicipalityModel> getMunicipalityById(String id) async {
    final db = await database;
    final maps = await db.query(
      DatabaseConstants.tableMunicipalities,
      where: '${DatabaseConstants.municipalityId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      throw Exception('Municipality with id $id not found');
    }

    return MunicipalityModel.fromMap(maps.first);
  }

  @override
  Future<List<MunicipalityModel>> searchMunicipalities(
      String departmentId, String query) async {
    final db = await database;
    final maps = await db.query(
      DatabaseConstants.tableMunicipalities,
      where: '''
        ${DatabaseConstants.municipalityDepartmentId} = ? AND 
        ${DatabaseConstants.municipalityIsActive} = ? AND (
          ${DatabaseConstants.municipalityName} LIKE ? OR 
          ${DatabaseConstants.municipalityCode} LIKE ?
        )
      ''',
      whereArgs: [departmentId, 1, '%$query%', '%$query%'],
      orderBy: DatabaseConstants.municipalityName,
    );

    return maps.map((map) => MunicipalityModel.fromMap(map)).toList();
  }

  @override
  Future<void> cacheCountries(List<CountryModel> countries) async {
    final db = await database;
    final batch = db.batch();

    for (final country in countries) {
      batch.insert(
        DatabaseConstants.tableCountries,
        country.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<void> cacheDepartments(List<DepartmentModel> departments) async {
    final db = await database;
    final batch = db.batch();

    for (final department in departments) {
      batch.insert(
        DatabaseConstants.tableDepartments,
        department.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<void> cacheMunicipalities(
      List<MunicipalityModel> municipalities) async {
    final db = await database;
    final batch = db.batch();

    for (final municipality in municipalities) {
      batch.insert(
        DatabaseConstants.tableMunicipalities,
        municipality.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }
}
