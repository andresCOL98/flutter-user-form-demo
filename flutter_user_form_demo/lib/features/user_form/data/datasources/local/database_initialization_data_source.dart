import 'package:sqflite/sqflite.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/constants/database_constants.dart';

abstract class DatabaseInitializationDataSource {
  Future<DatabaseInitializationResult> initializeAndVerifyDatabase();
}

class DatabaseInitializationDataSourceImpl
    implements DatabaseInitializationDataSource {
  @override
  Future<DatabaseInitializationResult> initializeAndVerifyDatabase() async {
    try {
      // Get database instance from DI container
      final database = await GetIt.instance.getAsync<Database>();

      // Verify initial data was seeded
      final countryCount = Sqflite.firstIntValue(await database.rawQuery(
              'SELECT COUNT(*) FROM ${DatabaseConstants.tableCountries}')) ??
          0;

      final departmentCount = Sqflite.firstIntValue(await database.rawQuery(
              'SELECT COUNT(*) FROM ${DatabaseConstants.tableDepartments}')) ??
          0;

      final municipalityCount = Sqflite.firstIntValue(await database.rawQuery(
              'SELECT COUNT(*) FROM ${DatabaseConstants.tableMunicipalities}')) ??
          0;

      return DatabaseInitializationResult(
        isSuccess: true,
        databasePath: database.path,
        countryCount: countryCount,
        departmentCount: departmentCount,
        municipalityCount: municipalityCount,
      );
    } catch (e) {
      return DatabaseInitializationResult(
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }
}

class DatabaseInitializationResult {
  final bool isSuccess;
  final String? databasePath;
  final int? countryCount;
  final int? departmentCount;
  final int? municipalityCount;
  final String? errorMessage;

  const DatabaseInitializationResult({
    required this.isSuccess,
    this.databasePath,
    this.countryCount,
    this.departmentCount,
    this.municipalityCount,
    this.errorMessage,
  });

  @override
  String toString() {
    if (isSuccess) {
      return 'Database initialized successfully at: $databasePath\n'
          'Initial data loaded:\n'
          '  - Countries: $countryCount\n'
          '  - Departments: $departmentCount\n'
          '  - Municipalities: $municipalityCount';
    } else {
      return 'Database initialization failed: $errorMessage';
    }
  }
}
