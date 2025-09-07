import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_user_form_demo/core/errors/failures.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/user.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/address.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/country.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/department.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/municipality.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/repositories/user_repository.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/repositories/location_repository.dart';

/// MockUserRepository with explicit type parameterization
class MockUserRepository extends Mock implements UserRepository {
  @override
  Future<Either<Failure, User>> createUser(User user) => (super.noSuchMethod(
        Invocation.method(#createUser, [user]),
        returnValue: Future<Either<Failure, User>>.value(
          Right(User(
            id: '1',
            firstName: 'Test',
            lastName: 'User',
            dateOfBirth: DateTime(1990, 1, 1),
            createdAt: DateTime.now(),
          )),
        ),
      ) as Future<Either<Failure, User>>);

  @override
  Future<Either<Failure, User>> getUserById(String userId) =>
      (super.noSuchMethod(
        Invocation.method(#getUserById, [userId]),
        returnValue: Future<Either<Failure, User>>.value(
          Right(User(
            id: userId,
            firstName: 'Test',
            lastName: 'User',
            dateOfBirth: DateTime(1990, 1, 1),
            createdAt: DateTime.now(),
          )),
        ),
      ) as Future<Either<Failure, User>>);

  @override
  Future<Either<Failure, User>> updateUser(User user) => (super.noSuchMethod(
        Invocation.method(#updateUser, [user]),
        returnValue: Future<Either<Failure, User>>.value(Right(user)),
      ) as Future<Either<Failure, User>>);

  @override
  Future<Either<Failure, void>> deleteUser(String userId) =>
      (super.noSuchMethod(
        Invocation.method(#deleteUser, [userId]),
        returnValue: Future<Either<Failure, void>>.value(const Right(null)),
      ) as Future<Either<Failure, void>>);

  @override
  Future<Either<Failure, List<User>>> getAllUsers() => (super.noSuchMethod(
        Invocation.method(#getAllUsers, []),
        returnValue: Future<Either<Failure, List<User>>>.value(Right(<User>[])),
      ) as Future<Either<Failure, List<User>>>);

  @override
  Future<Either<Failure, List<User>>> searchUsersByName(String name) =>
      (super.noSuchMethod(
        Invocation.method(#searchUsersByName, [name]),
        returnValue: Future<Either<Failure, List<User>>>.value(Right(<User>[])),
      ) as Future<Either<Failure, List<User>>>);

  @override
  Future<Either<Failure, User>> addAddressToUser(
          String userId, Address address) =>
      (super.noSuchMethod(
        Invocation.method(#addAddressToUser, [userId, address]),
        returnValue: Future<Either<Failure, User>>.value(
          Right(User(
            id: userId,
            firstName: 'Test',
            lastName: 'User',
            dateOfBirth: DateTime(1990, 1, 1),
            createdAt: DateTime.now(),
          )),
        ),
      ) as Future<Either<Failure, User>>);

  @override
  Future<Either<Failure, User>> updateUserAddress(
          String userId, Address address) =>
      (super.noSuchMethod(
        Invocation.method(#updateUserAddress, [userId, address]),
        returnValue: Future<Either<Failure, User>>.value(
          Right(User(
            id: userId,
            firstName: 'Test',
            lastName: 'User',
            dateOfBirth: DateTime(1990, 1, 1),
            createdAt: DateTime.now(),
          )),
        ),
      ) as Future<Either<Failure, User>>);

  @override
  Future<Either<Failure, User>> removeUserAddress(
          String userId, String addressId) =>
      (super.noSuchMethod(
        Invocation.method(#removeUserAddress, [userId, addressId]),
        returnValue: Future<Either<Failure, User>>.value(
          Right(User(
            id: userId,
            firstName: 'Test',
            lastName: 'User',
            dateOfBirth: DateTime(1990, 1, 1),
            createdAt: DateTime.now(),
          )),
        ),
      ) as Future<Either<Failure, User>>);

  @override
  Future<Either<Failure, User>> setPrimaryAddress(
          String userId, String addressId) =>
      (super.noSuchMethod(
        Invocation.method(#setPrimaryAddress, [userId, addressId]),
        returnValue: Future<Either<Failure, User>>.value(
          Right(User(
            id: userId,
            firstName: 'Test',
            lastName: 'User',
            dateOfBirth: DateTime(1990, 1, 1),
            createdAt: DateTime.now(),
          )),
        ),
      ) as Future<Either<Failure, User>>);
}

/// MockLocationRepository with explicit type parameterization
class MockLocationRepository extends Mock implements LocationRepository {
  @override
  Future<Either<Failure, List<Country>>> getCountries() => (super.noSuchMethod(
        Invocation.method(#getCountries, []),
        returnValue:
            Future<Either<Failure, List<Country>>>.value(Right(<Country>[])),
      ) as Future<Either<Failure, List<Country>>>);

  @override
  Future<Either<Failure, Country>> getCountryById(String countryId) =>
      (super.noSuchMethod(
        Invocation.method(#getCountryById, [countryId]),
        returnValue: Future<Either<Failure, Country>>.value(
          const Right(
              Country(id: 'CO', name: 'Colombia', code: 'CO', isActive: true)),
        ),
      ) as Future<Either<Failure, Country>>);

  @override
  Future<Either<Failure, List<Country>>> searchCountries(String query) =>
      (super.noSuchMethod(
        Invocation.method(#searchCountries, [query]),
        returnValue:
            Future<Either<Failure, List<Country>>>.value(Right(<Country>[])),
      ) as Future<Either<Failure, List<Country>>>);

  @override
  Future<Either<Failure, List<Department>>> getDepartmentsByCountry(
          String countryId) =>
      (super.noSuchMethod(
        Invocation.method(#getDepartmentsByCountry, [countryId]),
        returnValue: Future<Either<Failure, List<Department>>>.value(
            Right(<Department>[])),
      ) as Future<Either<Failure, List<Department>>>);

  @override
  Future<Either<Failure, Department>> getDepartmentById(String departmentId) =>
      (super.noSuchMethod(
        Invocation.method(#getDepartmentById, [departmentId]),
        returnValue: Future<Either<Failure, Department>>.value(
          const Right(Department(
            id: 'ANT',
            name: 'Antioquia',
            countryId: 'CO',
            code: '05',
          )),
        ),
      ) as Future<Either<Failure, Department>>);

  @override
  Future<Either<Failure, List<Department>>> searchDepartments(
    String countryId,
    String query,
  ) =>
      (super.noSuchMethod(
        Invocation.method(#searchDepartments, [countryId, query]),
        returnValue: Future<Either<Failure, List<Department>>>.value(
            Right(<Department>[])),
      ) as Future<Either<Failure, List<Department>>>);

  @override
  Future<Either<Failure, List<Municipality>>> getMunicipalitiesByDepartment(
    String departmentId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(#getMunicipalitiesByDepartment, [departmentId]),
        returnValue: Future<Either<Failure, List<Municipality>>>.value(
            Right(<Municipality>[])),
      ) as Future<Either<Failure, List<Municipality>>>);

  @override
  Future<Either<Failure, Municipality>> getMunicipalityById(
          String municipalityId) =>
      (super.noSuchMethod(
        Invocation.method(#getMunicipalityById, [municipalityId]),
        returnValue: Future<Either<Failure, Municipality>>.value(
          const Right(Municipality(
            id: 'MED',
            name: 'Medellín',
            departmentId: 'ANT',
            code: '001',
          )),
        ),
      ) as Future<Either<Failure, Municipality>>);

  @override
  Future<Either<Failure, List<Municipality>>> searchMunicipalities(
    String departmentId,
    String query,
  ) =>
      (super.noSuchMethod(
        Invocation.method(#searchMunicipalities, [departmentId, query]),
        returnValue: Future<Either<Failure, List<Municipality>>>.value(
            Right(<Municipality>[])),
      ) as Future<Either<Failure, List<Municipality>>>);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getLocationHierarchy(
    String countryId,
    String departmentId,
    String municipalityId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
            #getLocationHierarchy, [countryId, departmentId, municipalityId]),
        returnValue: Future<Either<Failure, Map<String, dynamic>>>.value(
          Right(<String, dynamic>{}),
        ),
      ) as Future<Either<Failure, Map<String, dynamic>>>);

  @override
  Future<Either<Failure, bool>> validateLocationHierarchy(
    String countryId,
    String departmentId,
    String municipalityId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(#validateLocationHierarchy,
            [countryId, departmentId, municipalityId]),
        returnValue: Future<Either<Failure, bool>>.value(const Right(true)),
      ) as Future<Either<Failure, bool>>);
}
