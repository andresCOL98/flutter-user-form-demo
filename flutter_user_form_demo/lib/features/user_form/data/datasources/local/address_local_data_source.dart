import 'package:sqflite/sqflite.dart';

import '../../../../../core/constants/database_constants.dart';
import '../../models/address_model.dart';

abstract class AddressLocalDataSource {
  Future<AddressModel> createAddress(AddressModel address);
  Future<AddressModel?> getAddressById(String addressId);
  Future<List<AddressModel>> getAddressesByUserId(String userId);
  Future<AddressModel> updateAddress(AddressModel address);
  Future<void> deleteAddress(String addressId);
  Future<void> setPrimaryAddress(String userId, String addressId);
}

class AddressLocalDataSourceImpl implements AddressLocalDataSource {
  final Database database;

  AddressLocalDataSourceImpl({required this.database});

  @override
  Future<AddressModel> createAddress(AddressModel address) async {
    // If this is set as primary, make sure no other addresses are primary for this user
    if (address.isPrimary) {
      await _clearPrimaryAddresses(address.userId);
    }

    final addressMap = address.toMap();

    await database.insert(
      DatabaseConstants.tableAddresses,
      addressMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return address;
  }

  @override
  Future<AddressModel?> getAddressById(String addressId) async {
    final List<Map<String, dynamic>> maps = await database.query(
      DatabaseConstants.tableAddresses,
      where:
          '${DatabaseConstants.addressId} = ? AND ${DatabaseConstants.addressIsActive} = ?',
      whereArgs: [addressId, 1],
    );

    if (maps.isNotEmpty) {
      return AddressModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<AddressModel>> getAddressesByUserId(String userId) async {
    final List<Map<String, dynamic>> maps = await database.query(
      DatabaseConstants.tableAddresses,
      where:
          '${DatabaseConstants.addressUserId} = ? AND ${DatabaseConstants.addressIsActive} = ?',
      whereArgs: [userId, 1],
      orderBy:
          '${DatabaseConstants.addressIsPrimary} DESC, ${DatabaseConstants.addressCreatedAt} DESC',
    );

    return List.generate(maps.length, (i) {
      return AddressModel.fromMap(maps[i]);
    });
  }

  @override
  Future<AddressModel> updateAddress(AddressModel address) async {
    // If this is set as primary, make sure no other addresses are primary for this user
    if (address.isPrimary) {
      await _clearPrimaryAddresses(address.userId);
    }

    await database.update(
      DatabaseConstants.tableAddresses,
      address.toMap(),
      where: '${DatabaseConstants.addressId} = ?',
      whereArgs: [address.id],
    );
    return address;
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    // Soft delete: mark as inactive instead of actual deletion
    await database.update(
      DatabaseConstants.tableAddresses,
      {
        DatabaseConstants.addressIsActive: 0,
        DatabaseConstants.addressUpdatedAt: DateTime.now().toIso8601String(),
      },
      where: '${DatabaseConstants.addressId} = ?',
      whereArgs: [addressId],
    );
  }

  @override
  Future<void> setPrimaryAddress(String userId, String addressId) async {
    await database.transaction((txn) async {
      // Clear all primary addresses for this user
      await txn.update(
        DatabaseConstants.tableAddresses,
        {
          DatabaseConstants.addressIsPrimary: 0,
          DatabaseConstants.addressUpdatedAt: DateTime.now().toIso8601String(),
        },
        where:
            '${DatabaseConstants.addressUserId} = ? AND ${DatabaseConstants.addressIsActive} = ?',
        whereArgs: [userId, 1],
      );

      // Set the specified address as primary
      await txn.update(
        DatabaseConstants.tableAddresses,
        {
          DatabaseConstants.addressIsPrimary: 1,
          DatabaseConstants.addressUpdatedAt: DateTime.now().toIso8601String(),
        },
        where:
            '${DatabaseConstants.addressId} = ? AND ${DatabaseConstants.addressIsActive} = ?',
        whereArgs: [addressId, 1],
      );
    });
  }

  /// Helper method to clear all primary addresses for a user
  Future<void> _clearPrimaryAddresses(String userId) async {
    await database.update(
      DatabaseConstants.tableAddresses,
      {
        DatabaseConstants.addressIsPrimary: 0,
        DatabaseConstants.addressUpdatedAt: DateTime.now().toIso8601String(),
      },
      where:
          '${DatabaseConstants.addressUserId} = ? AND ${DatabaseConstants.addressIsActive} = ?',
      whereArgs: [userId, 1],
    );
  }
}
