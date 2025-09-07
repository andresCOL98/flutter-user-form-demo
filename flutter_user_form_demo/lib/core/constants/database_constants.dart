class DatabaseConstants {
  static const String databaseName = 'user_form_db.db';
  static const int databaseVersion = 1;

  static const String tableUsers = 'users';
  static const String tableAddresses = 'addresses';
  static const String tableCountries = 'countries';
  static const String tableDepartments = 'departments';
  static const String tableMunicipalities = 'municipalities';

  static const String userId = 'id';
  static const String userFirstName = 'first_name';
  static const String userLastName = 'last_name';
  static const String userDateOfBirth = 'date_of_birth';
  static const String userEmail = 'email';
  static const String userPhoneNumber = 'phone_number';
  static const String userIsActive = 'is_active';
  static const String userCreatedAt = 'created_at';
  static const String userUpdatedAt = 'updated_at';

  static const String addressId = 'id';
  static const String addressUserId = 'user_id';
  static const String addressStreet = 'street';
  static const String addressStreet2 = 'street2';
  static const String addressCity = 'city';
  static const String addressPostalCode = 'postal_code';
  static const String addressCountryId = 'country_id';
  static const String addressDepartmentId = 'department_id';
  static const String addressMunicipalityId = 'municipality_id';
  static const String addressNotes = 'notes';
  static const String addressIsPrimary = 'is_primary';
  static const String addressIsActive = 'is_active';
  static const String addressCreatedAt = 'created_at';
  static const String addressUpdatedAt = 'updated_at';

  static const String countryId = 'id';
  static const String countryName = 'name';
  static const String countryCode = 'code';
  static const String countryIsActive = 'is_active';
  static const String countryCreatedAt = 'created_at';
  static const String countryUpdatedAt = 'updated_at';

  static const String departmentId = 'id';
  static const String departmentName = 'name';
  static const String departmentCode = 'code';
  static const String departmentCountryId = 'country_id';
  static const String departmentIsActive = 'is_active';
  static const String departmentCreatedAt = 'created_at';
  static const String departmentUpdatedAt = 'updated_at';

  static const String municipalityId = 'id';
  static const String municipalityName = 'name';
  static const String municipalityCode = 'code';
  static const String municipalityDepartmentId = 'department_id';
  static const String municipalityIsActive = 'is_active';
  static const String municipalityCreatedAt = 'created_at';
  static const String municipalityUpdatedAt = 'updated_at';

  static const List<String> createTableStatements = [
    '''
    CREATE TABLE $tableCountries (
      $countryId TEXT PRIMARY KEY,
      $countryName TEXT NOT NULL,
      $countryCode TEXT NOT NULL,
      $countryIsActive INTEGER NOT NULL DEFAULT 1,
      $countryCreatedAt TEXT NOT NULL,
      $countryUpdatedAt TEXT NOT NULL
    )
    ''',
    '''
    CREATE TABLE $tableDepartments (
      $departmentId TEXT PRIMARY KEY,
      $departmentName TEXT NOT NULL,
      $departmentCode TEXT NOT NULL,
      $departmentCountryId TEXT NOT NULL,
      $departmentIsActive INTEGER NOT NULL DEFAULT 1,
      $departmentCreatedAt TEXT NOT NULL,
      $departmentUpdatedAt TEXT NOT NULL,
      FOREIGN KEY ($departmentCountryId) 
        REFERENCES $tableCountries($countryId)
        ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE $tableMunicipalities (
      $municipalityId TEXT PRIMARY KEY,
      $municipalityName TEXT NOT NULL,
      $municipalityCode TEXT NOT NULL,
      $municipalityDepartmentId TEXT NOT NULL,
      $municipalityIsActive INTEGER NOT NULL DEFAULT 1,
      $municipalityCreatedAt TEXT NOT NULL,
      $municipalityUpdatedAt TEXT NOT NULL,
      FOREIGN KEY ($municipalityDepartmentId) 
        REFERENCES $tableDepartments($departmentId)
        ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE $tableUsers (
      $userId TEXT PRIMARY KEY,
      $userFirstName TEXT NOT NULL,
      $userLastName TEXT NOT NULL,
      $userDateOfBirth TEXT NOT NULL,
      $userEmail TEXT,
      $userPhoneNumber TEXT,
      $userIsActive INTEGER NOT NULL DEFAULT 1,
      $userCreatedAt TEXT NOT NULL,
      $userUpdatedAt TEXT
    )
    ''',
    '''
    CREATE TABLE $tableAddresses (
      $addressId TEXT PRIMARY KEY,
      $addressUserId TEXT NOT NULL,
      $addressStreet TEXT NOT NULL,
      $addressStreet2 TEXT,
      $addressCity TEXT NOT NULL,
      $addressPostalCode TEXT NOT NULL,
      $addressCountryId TEXT NOT NULL,
      $addressDepartmentId TEXT NOT NULL,
      $addressMunicipalityId TEXT NOT NULL,
      $addressNotes TEXT,
      $addressIsPrimary INTEGER NOT NULL DEFAULT 0,
      $addressIsActive INTEGER NOT NULL DEFAULT 1,
      $addressCreatedAt TEXT NOT NULL,
      $addressUpdatedAt TEXT,
      FOREIGN KEY ($addressUserId) 
        REFERENCES $tableUsers($userId)
        ON DELETE CASCADE,
      FOREIGN KEY ($addressCountryId) 
        REFERENCES $tableCountries($countryId),
      FOREIGN KEY ($addressDepartmentId) 
        REFERENCES $tableDepartments($departmentId),
      FOREIGN KEY ($addressMunicipalityId) 
        REFERENCES $tableMunicipalities($municipalityId)
    )
    '''
  ];

  static const List<String> createIndexStatements = [
    '''
    CREATE INDEX idx_departments_country 
    ON $tableDepartments($departmentCountryId)
    ''',
    '''
    CREATE INDEX idx_municipalities_department 
    ON $tableMunicipalities($municipalityDepartmentId)
    ''',
    '''
    CREATE INDEX idx_addresses_user 
    ON $tableAddresses($addressUserId)
    ''',
    '''
    CREATE INDEX idx_addresses_country 
    ON $tableAddresses($addressCountryId)
    ''',
    '''
    CREATE INDEX idx_addresses_department 
    ON $tableAddresses($addressDepartmentId)
    ''',
    '''
    CREATE INDEX idx_addresses_municipality 
    ON $tableAddresses($addressMunicipalityId)
    ''',
  ];
}
