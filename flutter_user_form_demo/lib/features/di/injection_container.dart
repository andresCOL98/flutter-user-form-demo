import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../core/constants/database_constants.dart';

// Data sources
import '../user_form/data/datasources/local/location_local_data_source.dart';
import '../user_form/data/datasources/local/database_initialization_data_source.dart';
import '../user_form/data/datasources/local/user_local_data_source.dart';
import '../user_form/data/datasources/local/address_local_data_source.dart';
import '../user_form/data/datasources/remote/location_remote_data_source.dart';

// Repositories
import '../user_form/data/repositories/location_repository_impl.dart';
import '../user_form/data/repositories/user_repository_impl.dart';
import '../user_form/domain/repositories/location_repository.dart';
import '../user_form/domain/repositories/user_repository.dart';

// Use cases
import '../user_form/domain/usecases/get_countries_usecase.dart';
import '../user_form/domain/usecases/get_departments_usecase.dart';
import '../user_form/domain/usecases/get_municipalities_usecase.dart';
import '../user_form/domain/usecases/create_user_usecase.dart';
import '../user_form/domain/usecases/update_user_usecase.dart';
import '../user_form/domain/usecases/get_users_usecase.dart';
import '../user_form/domain/usecases/get_user_usecase.dart';
import '../user_form/domain/usecases/add_address_usecase.dart';

// BLoCs
import '../user_form/presentation/bloc/location_bloc.dart';
import '../user_form/presentation/bloc/user_form_bloc.dart';
import '../user_form/presentation/bloc/user_list_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Register database instance
  getIt.registerSingletonAsync<Database>(() => _initializeDatabase());

  await _registerDataSources();
  await _registerRepositories();
  await _registerUseCases();
  await _registerBlocs();

  print('🔧 DI container configured successfully');
}

Future<void> _registerDataSources() async {
  // Location data sources
  getIt.registerLazySingleton<LocationLocalDataSource>(
    () => LocationLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<LocationRemoteDataSource>(
    () => LocationRemoteDataSourceImpl(),
  );

  // User data source (requires database)
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(database: getIt<Database>()),
  );

  // Address data source (requires database)
  getIt.registerLazySingleton<AddressLocalDataSource>(
    () => AddressLocalDataSourceImpl(database: getIt<Database>()),
  );

  // Database initialization data source
  getIt.registerLazySingleton<DatabaseInitializationDataSource>(
    () => DatabaseInitializationDataSourceImpl(),
  );
}

Future<void> _registerRepositories() async {
  // Location repository
  getIt.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
      localDataSource: getIt<LocationLocalDataSource>(),
      remoteDataSource: getIt<LocationRemoteDataSource>(),
    ),
  );

  // User repository
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      userLocalDataSource: getIt<UserLocalDataSource>(),
      addressLocalDataSource: getIt<AddressLocalDataSource>(),
    ),
  );
}

Future<void> _registerUseCases() async {
  // Location use cases
  getIt.registerLazySingleton<GetCountriesUseCase>(
    () => GetCountriesUseCase(getIt<LocationRepository>()),
  );

  getIt.registerLazySingleton<GetDepartmentsUseCase>(
    () => GetDepartmentsUseCase(getIt<LocationRepository>()),
  );

  getIt.registerLazySingleton<GetMunicipalitiesUseCase>(
    () => GetMunicipalitiesUseCase(getIt<LocationRepository>()),
  );

  // User use cases
  getIt.registerLazySingleton<CreateUserUseCase>(
    () => CreateUserUseCase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<UpdateUserUseCase>(
    () => UpdateUserUseCase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<GetUserUseCase>(
    () => GetUserUseCase(getIt<UserRepository>()),
  );

  // Address use cases
  getIt.registerLazySingleton<AddAddressUseCase>(
    () => AddAddressUseCase(
      userRepository: getIt<UserRepository>(),
      locationRepository: getIt<LocationRepository>(),
    ),
  );
}

Future<void> _registerBlocs() async {
  // Location BLoC
  getIt.registerFactory<LocationBloc>(
    () => LocationBloc(
      getCountriesUseCase: getIt<GetCountriesUseCase>(),
      getDepartmentsUseCase: getIt<GetDepartmentsUseCase>(),
      getMunicipalitiesUseCase: getIt<GetMunicipalitiesUseCase>(),
    ),
  );

  // User Form BLoC
  getIt.registerFactory<UserFormBloc>(
    () => UserFormBloc(
      createUserUseCase: getIt<CreateUserUseCase>(),
      updateUserUseCase: getIt<UpdateUserUseCase>(),
    ),
  );

  // User List BLoC
  getIt.registerFactory<UserListBloc>(
    () => UserListBloc(
      getUsersUseCase: getIt<GetUsersUseCase>(),
      getUserUseCase: getIt<GetUserUseCase>(),
    ),
  );
}

Future<Database> _initializeDatabase() async {
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
    // Colombia
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
    // Estados Unidos
    {
      DatabaseConstants.departmentId: 'CA',
      DatabaseConstants.departmentName: 'California',
      DatabaseConstants.departmentCode: 'CA',
      DatabaseConstants.departmentCountryId: 'US',
      DatabaseConstants.departmentIsActive: 1,
      DatabaseConstants.departmentCreatedAt: now,
      DatabaseConstants.departmentUpdatedAt: now,
    },
    {
      DatabaseConstants.departmentId: 'NY',
      DatabaseConstants.departmentName: 'New York',
      DatabaseConstants.departmentCode: 'NY',
      DatabaseConstants.departmentCountryId: 'US',
      DatabaseConstants.departmentIsActive: 1,
      DatabaseConstants.departmentCreatedAt: now,
      DatabaseConstants.departmentUpdatedAt: now,
    },
    // México
    {
      DatabaseConstants.departmentId: 'CDMX',
      DatabaseConstants.departmentName: 'Ciudad de México',
      DatabaseConstants.departmentCode: 'CDMX',
      DatabaseConstants.departmentCountryId: 'MX',
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
    // Antioquia - Colombia
    {
      DatabaseConstants.municipalityId: 'MED',
      DatabaseConstants.municipalityName: 'Medellín',
      DatabaseConstants.municipalityCode: '05001',
      DatabaseConstants.municipalityDepartmentId: 'ANT',
      DatabaseConstants.municipalityIsActive: 1,
      DatabaseConstants.municipalityCreatedAt: now,
      DatabaseConstants.municipalityUpdatedAt: now,
    },
    {
      DatabaseConstants.municipalityId: 'BEL',
      DatabaseConstants.municipalityName: 'Bello',
      DatabaseConstants.municipalityCode: '05088',
      DatabaseConstants.municipalityDepartmentId: 'ANT',
      DatabaseConstants.municipalityIsActive: 1,
      DatabaseConstants.municipalityCreatedAt: now,
      DatabaseConstants.municipalityUpdatedAt: now,
    },
    // Cundinamarca - Colombia
    {
      DatabaseConstants.municipalityId: 'BOG',
      DatabaseConstants.municipalityName: 'Bogotá',
      DatabaseConstants.municipalityCode: '25001',
      DatabaseConstants.municipalityDepartmentId: 'CUN',
      DatabaseConstants.municipalityIsActive: 1,
      DatabaseConstants.municipalityCreatedAt: now,
      DatabaseConstants.municipalityUpdatedAt: now,
    },
    {
      DatabaseConstants.municipalityId: 'SOP',
      DatabaseConstants.municipalityName: 'Soacha',
      DatabaseConstants.municipalityCode: '25754',
      DatabaseConstants.municipalityDepartmentId: 'CUN',
      DatabaseConstants.municipalityIsActive: 1,
      DatabaseConstants.municipalityCreatedAt: now,
      DatabaseConstants.municipalityUpdatedAt: now,
    },
    // Valle del Cauca - Colombia
    {
      DatabaseConstants.municipalityId: 'CAL',
      DatabaseConstants.municipalityName: 'Cali',
      DatabaseConstants.municipalityCode: '76001',
      DatabaseConstants.municipalityDepartmentId: 'VAL',
      DatabaseConstants.municipalityIsActive: 1,
      DatabaseConstants.municipalityCreatedAt: now,
      DatabaseConstants.municipalityUpdatedAt: now,
    },
    // California - USA
    {
      DatabaseConstants.municipalityId: 'LA',
      DatabaseConstants.municipalityName: 'Los Angeles',
      DatabaseConstants.municipalityCode: 'LA',
      DatabaseConstants.municipalityDepartmentId: 'CA',
      DatabaseConstants.municipalityIsActive: 1,
      DatabaseConstants.municipalityCreatedAt: now,
      DatabaseConstants.municipalityUpdatedAt: now,
    },
    // New York - USA
    {
      DatabaseConstants.municipalityId: 'NYC',
      DatabaseConstants.municipalityName: 'New York City',
      DatabaseConstants.municipalityCode: 'NYC',
      DatabaseConstants.municipalityDepartmentId: 'NY',
      DatabaseConstants.municipalityIsActive: 1,
      DatabaseConstants.municipalityCreatedAt: now,
      DatabaseConstants.municipalityUpdatedAt: now,
    },
    // Ciudad de México - México
    {
      DatabaseConstants.municipalityId: 'MX_CDMX',
      DatabaseConstants.municipalityName: 'Ciudad de México',
      DatabaseConstants.municipalityCode: 'CDMX_01',
      DatabaseConstants.municipalityDepartmentId: 'CDMX',
      DatabaseConstants.municipalityIsActive: 1,
      DatabaseConstants.municipalityCreatedAt: now,
      DatabaseConstants.municipalityUpdatedAt: now,
    },
  ];

  for (final municipality in municipalities) {
    await db.insert(DatabaseConstants.tableMunicipalities, municipality);
  }
}
