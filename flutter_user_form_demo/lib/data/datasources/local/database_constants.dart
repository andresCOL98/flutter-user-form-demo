/// Database constants for table names, column names, and SQL configurations
class DatabaseConstants {
  // Database configuration
  static const String databaseName = 'user_form_demo.db';
  static const int databaseVersion = 1;

  // Table names
  static const String tableCountries = 'countries';
  static const String tableDepartments = 'departments';
  static const String tableMunicipalities = 'municipalities';
  static const String tableUsers = 'users';
  static const String tableAddresses = 'addresses';

  // Countries table columns
  static const String countryId = 'id';
  static const String countryName = 'name';
  static const String countryCode = 'code';
  static const String countryIsActive = 'is_active';
  static const String countryCreatedAt = 'created_at';
  static const String countryUpdatedAt = 'updated_at';

  // Departments table columns
  static const String departmentId = 'id';
  static const String departmentName = 'name';
  static const String departmentCode = 'code';
  static const String departmentCountryId = 'country_id';
  static const String departmentIsActive = 'is_active';
  static const String departmentCreatedAt = 'created_at';
  static const String departmentUpdatedAt = 'updated_at';

  // Municipalities table columns
  static const String municipalityId = 'id';
  static const String municipalityName = 'name';
  static const String municipalityCode = 'code';
  static const String municipalityDepartmentId = 'department_id';
  static const String municipalityIsActive = 'is_active';
  static const String municipalityCreatedAt = 'created_at';
  static const String municipalityUpdatedAt = 'updated_at';

  // Users table columns
  static const String userId = 'id';
  static const String userFirstName = 'first_name';
  static const String userLastName = 'last_name';
  static const String userEmail = 'email';
  static const String userPhoneNumber = 'phone_number';
  static const String userDateOfBirth = 'date_of_birth';
  static const String userIsActive = 'is_active';
  static const String userCreatedAt = 'created_at';
  static const String userUpdatedAt = 'updated_at';

  // Addresses table columns
  static const String addressId = 'id';
  static const String addressUserId = 'user_id';
  static const String addressStreet = 'street_address';
  static const String addressStreet2 = 'street_address_2';
  static const String addressCity = 'city';
  static const String addressCountryId = 'country_id';
  static const String addressDepartmentId = 'department_id';
  static const String addressMunicipalityId = 'municipality_id';
  static const String addressPostalCode = 'postal_code';
  static const String addressNotes = 'notes';
  static const String addressIsPrimary = 'is_primary';
  static const String addressIsActive = 'is_active';
  static const String addressCreatedAt = 'created_at';
  static const String addressUpdatedAt = 'updated_at';

  // SQL Create Statements
  static const String createCountriesTable = '''
    CREATE TABLE $tableCountries (
      $countryId TEXT PRIMARY KEY,
      $countryName TEXT NOT NULL UNIQUE,
      $countryCode TEXT NOT NULL UNIQUE,
      $countryIsActive INTEGER NOT NULL DEFAULT 1,
      $countryCreatedAt TEXT NOT NULL,
      $countryUpdatedAt TEXT NOT NULL
    )
  ''';

  static const String createDepartmentsTable = '''
    CREATE TABLE $tableDepartments (
      $departmentId TEXT PRIMARY KEY,
      $departmentName TEXT NOT NULL,
      $departmentCode TEXT NOT NULL,
      $departmentCountryId TEXT NOT NULL,
      $departmentIsActive INTEGER NOT NULL DEFAULT 1,
      $departmentCreatedAt TEXT NOT NULL,
      $departmentUpdatedAt TEXT NOT NULL,
      FOREIGN KEY ($departmentCountryId) REFERENCES $tableCountries ($countryId) ON DELETE CASCADE,
      UNIQUE($departmentName, $departmentCountryId),
      UNIQUE($departmentCode, $departmentCountryId)
    )
  ''';

  static const String createMunicipalitiesTable = '''
    CREATE TABLE $tableMunicipalities (
      $municipalityId TEXT PRIMARY KEY,
      $municipalityName TEXT NOT NULL,
      $municipalityCode TEXT NOT NULL,
      $municipalityDepartmentId TEXT NOT NULL,
      $municipalityIsActive INTEGER NOT NULL DEFAULT 1,
      $municipalityCreatedAt TEXT NOT NULL,
      $municipalityUpdatedAt TEXT NOT NULL,
      FOREIGN KEY ($municipalityDepartmentId) REFERENCES $tableDepartments ($departmentId) ON DELETE CASCADE,
      UNIQUE($municipalityName, $municipalityDepartmentId),
      UNIQUE($municipalityCode, $municipalityDepartmentId)
    )
  ''';

  static const String createUsersTable = '''
    CREATE TABLE $tableUsers (
      $userId TEXT PRIMARY KEY,
      $userFirstName TEXT NOT NULL,
      $userLastName TEXT NOT NULL,
      $userEmail TEXT UNIQUE,
      $userPhoneNumber TEXT,
      $userDateOfBirth TEXT NOT NULL,
      $userIsActive INTEGER NOT NULL DEFAULT 1,
      $userCreatedAt TEXT NOT NULL,
      $userUpdatedAt TEXT
    )
  ''';

  static const String createAddressesTable = '''
    CREATE TABLE $tableAddresses (
      $addressId TEXT PRIMARY KEY,
      $addressUserId TEXT NOT NULL,
      $addressStreet TEXT NOT NULL,
      $addressStreet2 TEXT,
      $addressCity TEXT NOT NULL,
      $addressCountryId TEXT NOT NULL,
      $addressDepartmentId TEXT NOT NULL,
      $addressMunicipalityId TEXT NOT NULL,
      $addressPostalCode TEXT NOT NULL,
      $addressNotes TEXT,
      $addressIsPrimary INTEGER NOT NULL DEFAULT 0,
      $addressIsActive INTEGER NOT NULL DEFAULT 1,
      $addressCreatedAt TEXT NOT NULL,
      $addressUpdatedAt TEXT,
      FOREIGN KEY ($addressUserId) REFERENCES $tableUsers ($userId) ON DELETE CASCADE,
      FOREIGN KEY ($addressCountryId) REFERENCES $tableCountries ($countryId) ON DELETE RESTRICT,
      FOREIGN KEY ($addressDepartmentId) REFERENCES $tableDepartments ($departmentId) ON DELETE RESTRICT,
      FOREIGN KEY ($addressMunicipalityId) REFERENCES $tableMunicipalities ($municipalityId) ON DELETE RESTRICT
    )
  ''';

  // Index creation statements
  static const String indexDepartmentsCountryId = '''
    CREATE INDEX idx_departments_country_id ON $tableDepartments ($departmentCountryId)
  ''';

  static const String indexMunicipalitiesDepartmentId = '''
    CREATE INDEX idx_municipalities_department_id ON $tableMunicipalities ($municipalityDepartmentId)
  ''';

  static const String indexAddressesUserId = '''
    CREATE INDEX idx_addresses_user_id ON $tableAddresses ($addressUserId)
  ''';

  static const String indexAddressesMunicipalityId = '''
    CREATE INDEX idx_addresses_municipality_id ON $tableAddresses ($addressMunicipalityId)
  ''';

  static const String indexAddressesCountryId = '''
    CREATE INDEX idx_addresses_country_id ON $tableAddresses ($addressCountryId)
  ''';

  static const String indexAddressesDepartmentId = '''
    CREATE INDEX idx_addresses_department_id ON $tableAddresses ($addressDepartmentId)
  ''';

  static const String indexUsersEmail = '''
    CREATE INDEX idx_users_email ON $tableUsers ($userEmail)
  ''';

  // All table creation statements in order (respecting foreign key dependencies)
  static const List<String> createTableStatements = [
    createCountriesTable,
    createDepartmentsTable,
    createMunicipalitiesTable,
    createUsersTable,
    createAddressesTable,
  ];

  // All index creation statements
  static const List<String> createIndexStatements = [
    indexDepartmentsCountryId,
    indexMunicipalitiesDepartmentId,
    indexAddressesUserId,
    indexAddressesMunicipalityId,
    indexAddressesCountryId,
    indexAddressesDepartmentId,
    indexUsersEmail,
  ];

  // Drop table statements (in reverse order for foreign key dependencies)
  static const List<String> dropTableStatements = [
    'DROP TABLE IF EXISTS $tableAddresses',
    'DROP TABLE IF EXISTS $tableUsers',
    'DROP TABLE IF EXISTS $tableMunicipalities',
    'DROP TABLE IF EXISTS $tableDepartments',
    'DROP TABLE IF EXISTS $tableCountries',
  ];
}
