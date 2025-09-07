import 'package:sqflite/sqflite.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';

import '../../core/constants/database_constants.dart';
import '../user_form/data/datasources/local/location_local_data_source.dart';

/// Módulo de configuración de la base de datos SQLite
/// Proporciona la configuración y inicialización de la base de datos local
@module
abstract class DatabaseModule {
  /// Proporciona la instancia de la base de datos SQLite
  @lazySingleton
  Future<Database> get database async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, DatabaseConstants.databaseName);

    return await openDatabase(
      path,
      version: DatabaseConstants.databaseVersion,
      onCreate: _createTables,
      onOpen: (db) async {
        // Habilitar claves foráneas
        await db.execute('PRAGMA foreign_keys = ON');
        await _seedInitialData(db);
      },
    );
  }

  @LazySingleton(as: LocationLocalDataSource)
  LocationLocalDataSourceImpl get locationLocalDataSource;
}

Future<void> _createTables(Database db, int version) async {
  for (final statement in DatabaseConstants.createTableStatements) {
    await db.execute(statement);
  }

  for (final statement in DatabaseConstants.createIndexStatements) {
    await db.execute(statement);
  }
}

Future<void> _seedInitialData(Database db) async {
  final countryCount = Sqflite.firstIntValue(
        await db.rawQuery(
            'SELECT COUNT(*) FROM ${DatabaseConstants.tableCountries}'),
      ) ??
      0;

  if (countryCount == 0) {
    await _insertInitialCountries(db);
    await _insertInitialDepartments(db);
    await _insertInitialMunicipalities(db);
  }
}

Future<void> _insertInitialCountries(Database db) async {
  final now = DateTime.now().toIso8601String();
  final countries = [
    {
      DatabaseConstants.countryId: 'CO',
      DatabaseConstants.countryName: 'Colombia',
      DatabaseConstants.countryCode: 'CO',
      DatabaseConstants.countryIsActive: 1,
      DatabaseConstants.countryCreatedAt: now,
      DatabaseConstants.countryUpdatedAt: now,
    },
    {
      DatabaseConstants.countryId: 'US',
      DatabaseConstants.countryName: 'Estados Unidos',
      DatabaseConstants.countryCode: 'US',
      DatabaseConstants.countryIsActive: 1,
      DatabaseConstants.countryCreatedAt: now,
      DatabaseConstants.countryUpdatedAt: now,
    },
    {
      DatabaseConstants.countryId: 'MX',
      DatabaseConstants.countryName: 'México',
      DatabaseConstants.countryCode: 'MX',
      DatabaseConstants.countryIsActive: 1,
      DatabaseConstants.countryCreatedAt: now,
      DatabaseConstants.countryUpdatedAt: now,
    },
  ];

  for (final country in countries) {
    await db.insert(DatabaseConstants.tableCountries, country);
  }
}

Future<void> _insertInitialDepartments(Database db) async {
  final now = DateTime.now().toIso8601String();
  final departments = [
    {
      DatabaseConstants.departmentId: 'ANT',
      DatabaseConstants.departmentName: 'Antioquia',
      DatabaseConstants.departmentCode: '05',
      DatabaseConstants.departmentCountryId: 'CO',
      DatabaseConstants.departmentIsActive: 1,
      DatabaseConstants.departmentCreatedAt: now,
      DatabaseConstants.departmentUpdatedAt: now,
    },
    {
      DatabaseConstants.departmentId: 'CUN',
      DatabaseConstants.departmentName: 'Cundinamarca',
      DatabaseConstants.departmentCode: '25',
      DatabaseConstants.departmentCountryId: 'CO',
      DatabaseConstants.departmentIsActive: 1,
      DatabaseConstants.departmentCreatedAt: now,
      DatabaseConstants.departmentUpdatedAt: now,
    },
    {
      DatabaseConstants.departmentId: 'VAL',
      DatabaseConstants.departmentName: 'Valle del Cauca',
      DatabaseConstants.departmentCode: '76',
      DatabaseConstants.departmentCountryId: 'CO',
      DatabaseConstants.departmentIsActive: 1,
      DatabaseConstants.departmentCreatedAt: now,
      DatabaseConstants.departmentUpdatedAt: now,
    },
    {
      DatabaseConstants.departmentId: 'ATL',
      DatabaseConstants.departmentName: 'Atlántico',
      DatabaseConstants.departmentCode: '08',
      DatabaseConstants.departmentCountryId: 'CO',
      DatabaseConstants.departmentIsActive: 1,
      DatabaseConstants.departmentCreatedAt: now,
      DatabaseConstants.departmentUpdatedAt: now,
    },
  ];

  for (final department in departments) {
    await db.insert(DatabaseConstants.tableDepartments, department);
  }
}

Future<void> _insertInitialMunicipalities(Database db) async {
  final now = DateTime.now().toIso8601String();
  final municipalities = [
    {
      DatabaseConstants.municipalityId: 'MED',
      DatabaseConstants.municipalityName: 'Medellín',
      DatabaseConstants.municipalityCode: '001',
      DatabaseConstants.municipalityDepartmentId: 'ANT',
      DatabaseConstants.municipalityIsActive: 1,
      DatabaseConstants.municipalityCreatedAt: now,
      DatabaseConstants.municipalityUpdatedAt: now,
    },
    {
      DatabaseConstants.municipalityId: 'BEL',
      DatabaseConstants.municipalityName: 'Bello',
      DatabaseConstants.municipalityCode: '088',
      DatabaseConstants.municipalityDepartmentId: 'ANT',
      DatabaseConstants.municipalityIsActive: 1,
      DatabaseConstants.municipalityCreatedAt: now,
      DatabaseConstants.municipalityUpdatedAt: now,
    },
    {
      DatabaseConstants.municipalityId: 'BOG',
      DatabaseConstants.municipalityName: 'Bogotá D.C.',
      DatabaseConstants.municipalityCode: '001',
      DatabaseConstants.municipalityDepartmentId: 'CUN',
      DatabaseConstants.municipalityIsActive: 1,
      DatabaseConstants.municipalityCreatedAt: now,
      DatabaseConstants.municipalityUpdatedAt: now,
    },
    {
      DatabaseConstants.municipalityId: 'CAL',
      DatabaseConstants.municipalityName: 'Cali',
      DatabaseConstants.municipalityCode: '001',
      DatabaseConstants.municipalityDepartmentId: 'VAL',
      DatabaseConstants.municipalityIsActive: 1,
      DatabaseConstants.municipalityCreatedAt: now,
      DatabaseConstants.municipalityUpdatedAt: now,
    },
    {
      DatabaseConstants.municipalityId: 'BAR',
      DatabaseConstants.municipalityName: 'Barranquilla',
      DatabaseConstants.municipalityCode: '001',
      DatabaseConstants.municipalityDepartmentId: 'ATL',
      DatabaseConstants.municipalityIsActive: 1,
      DatabaseConstants.municipalityCreatedAt: now,
      DatabaseConstants.municipalityUpdatedAt: now,
    },
  ];

  for (final municipality in municipalities) {
    await db.insert(DatabaseConstants.tableMunicipalities, municipality);
  }
}
