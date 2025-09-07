import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../core/constants/database_constants.dart';
import '../../models/user_model.dart';
import '../../models/address_model.dart';

abstract class UserLocalDataSource {
  Future<UserModel> createUser(UserModel user);
  Future<UserModel?> getUserById(String userId);
  Future<List<UserModel>> getAllUsers();
  Future<List<UserModel>> searchUsersByName(String name);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(String userId);
}

@Injectable(as: UserLocalDataSource)
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Database database;

  UserLocalDataSourceImpl({required this.database});

  @override
  Future<UserModel> createUser(UserModel user) async {
    await database.insert(
      DatabaseConstants.tableUsers,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return user;
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    final List<Map<String, dynamic>> maps = await database.query(
      DatabaseConstants.tableUsers,
      where:
          '${DatabaseConstants.userId} = ? AND ${DatabaseConstants.userIsActive} = ?',
      whereArgs: [userId, 1],
    );

    if (maps.isNotEmpty) {
      final user = UserModel.fromMap(maps.first);

      final addressMaps = await database.query(
        DatabaseConstants.tableAddresses,
        where:
            '${DatabaseConstants.addressUserId} = ? AND ${DatabaseConstants.addressIsActive} = ?',
        whereArgs: [userId, 1],
        orderBy: '${DatabaseConstants.addressCreatedAt} ASC',
      );

      if (addressMaps.isNotEmpty) {
        for (var addressMap in addressMaps) {
          debugPrint(
              '   - ${addressMap['street']} (Active: ${addressMap['is_active']})');
        }
      }

      final addresses = addressMaps
          .map((addressMap) => AddressModel.fromMap(addressMap))
          .toList();

      // Return user with loaded addresses
      return UserModel(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        dateOfBirth: user.dateOfBirth,
        email: user.email,
        phoneNumber: user.phoneNumber,
        addresses: addresses,
        isActive: user.isActive,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      );
    }

    return null;
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final List<Map<String, dynamic>> maps = await database.query(
      DatabaseConstants.tableUsers,
      where: '${DatabaseConstants.userIsActive} = ?',
      whereArgs: [1],
      orderBy: '${DatabaseConstants.userCreatedAt} DESC',
    );

    final List<UserModel> users = [];

    for (final userMap in maps) {
      final user = UserModel.fromMap(userMap);

      // Load addresses for this user
      final addressMaps = await database.query(
        DatabaseConstants.tableAddresses,
        where:
            '${DatabaseConstants.addressUserId} = ? AND ${DatabaseConstants.addressIsActive} = ?',
        whereArgs: [user.id, 1],
        orderBy: '${DatabaseConstants.addressCreatedAt} ASC',
      );

      final addresses = addressMaps
          .map((addressMap) => AddressModel.fromMap(addressMap))
          .toList();

      // Add user with loaded addresses
      users.add(UserModel(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        dateOfBirth: user.dateOfBirth,
        email: user.email,
        phoneNumber: user.phoneNumber,
        addresses: addresses,
        isActive: user.isActive,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      ));
    }

    return users;
  }

  @override
  Future<List<UserModel>> searchUsersByName(String name) async {
    final String searchQuery = '%$name%';
    final List<Map<String, dynamic>> maps = await database.query(
      DatabaseConstants.tableUsers,
      where: '''
        (${DatabaseConstants.userFirstName} LIKE ? OR ${DatabaseConstants.userLastName} LIKE ?) 
        AND ${DatabaseConstants.userIsActive} = ?
      ''',
      whereArgs: [searchQuery, searchQuery, 1],
      orderBy: '${DatabaseConstants.userCreatedAt} DESC',
    );

    final List<UserModel> users = [];

    for (final userMap in maps) {
      final user = UserModel.fromMap(userMap);

      // Load addresses for this user
      final addressMaps = await database.query(
        DatabaseConstants.tableAddresses,
        where:
            '${DatabaseConstants.addressUserId} = ? AND ${DatabaseConstants.addressIsActive} = ?',
        whereArgs: [user.id, 1],
        orderBy: '${DatabaseConstants.addressCreatedAt} ASC',
      );

      final addresses = addressMaps
          .map((addressMap) => AddressModel.fromMap(addressMap))
          .toList();

      // Add user with loaded addresses
      users.add(UserModel(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        dateOfBirth: user.dateOfBirth,
        email: user.email,
        phoneNumber: user.phoneNumber,
        addresses: addresses,
        isActive: user.isActive,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      ));
    }

    return users;
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    await database.update(
      DatabaseConstants.tableUsers,
      user.toMap(),
      where: '${DatabaseConstants.userId} = ?',
      whereArgs: [user.id],
    );
    return user;
  }

  @override
  Future<void> deleteUser(String userId) async {
    // Soft delete: mark as inactive instead of actual deletion
    await database.update(
      DatabaseConstants.tableUsers,
      {
        DatabaseConstants.userIsActive: 0,
        DatabaseConstants.userUpdatedAt: DateTime.now().toIso8601String(),
      },
      where: '${DatabaseConstants.userId} = ?',
      whereArgs: [userId],
    );
  }
}
