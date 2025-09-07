import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../../di/injection_container.dart';
import '../pages/address_form_page.dart';

class UserDetailLogic {
  static late GetUserUseCase _getUserUseCase;

  static void initialize() {
    _getUserUseCase = getIt<GetUserUseCase>();
  }

  /// Carga el usuario con sus direcciones
  static Future<User?> loadUserWithAddresses(String userId) async {
    print('🔍 Loading user with addresses for ID: $userId');

    final result = await _getUserUseCase(GetUserParams(userId: userId));

    return result.fold(
      (failure) {
        print('❌ Error loading user: ${failure.message}');
        return null;
      },
      (user) {
        print('✅ User loaded successfully: ${user.fullName}');
        print('📍 User addresses count: ${user.addresses.length}');
        if (user.addresses.isNotEmpty) {
          print('📋 Addresses:');
          for (var i = 0; i < user.addresses.length; i++) {
            print('   ${i + 1}. ${user.addresses[i].streetAddress}');
          }
        }
        return user;
      },
    );
  }

  /// Navega al formulario de edición de usuario
  static void editUser(BuildContext context) {
    // TODO: Navigate to UserFormPage with edit mode
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Edit user functionality coming soon'),
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  /// Navega al formulario de agregar dirección
  static Future<bool> addAddress(BuildContext context, String userId) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => AddressFormPage(userId: userId),
      ),
    );

    return result ?? false;
  }

  /// Muestra un mensaje de error
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $message'),
        backgroundColor: Colors.red[700],
      ),
    );
  }
}
