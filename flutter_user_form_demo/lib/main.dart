import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'features/di/injection_container.dart';
import 'features/user_form/data/datasources/local/database_initialization_data_source.dart';
import 'features/user_form/presentation/user_form_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await configureDependencies();
    await GetIt.instance.allReady();

    await _initializeDatabase();

    runApp(const UserFormApp());
  } catch (e) {
    debugPrint('❌ Error durante la inicialización: ${e.toString()}');
    runApp(UserFormApp(
      initializationResult: DatabaseInitializationResult(
        isSuccess: false,
        errorMessage: 'Critical initialization error: ${e.toString()}',
      ),
    ));
  }
}

Future<void> _initializeDatabase() async {
  debugPrint('🔧 Initializing database...');

  final databaseInitializer =
      GetIt.instance<DatabaseInitializationDataSource>();
  final result = await databaseInitializer.initializeAndVerifyDatabase();

  if (result.isSuccess) {
    debugPrint('✅ Database initialized successfully');
    debugPrint('📊 Database path: ${result.databasePath}');
    debugPrint('📈 Initial data loaded:');
    debugPrint('   - Countries: ${result.countryCount}');
    debugPrint('   - Departments: ${result.departmentCount}');
    debugPrint('   - Municipalities: ${result.municipalityCount}');
  } else {
    debugPrint(' Error initializing database: ${result.errorMessage}');
    throw Exception('Database initialization failed: ${result.errorMessage}');
  }
}
