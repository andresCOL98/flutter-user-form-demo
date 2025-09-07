import 'package:flutter/material.dart';
import '../pages/user_list_page.dart';
import '../pages/user_form_page.dart';
import '../pages/address_form_page.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/address.dart';

class AppNavigator {
  static Future<T?> pushUserForm<T>(BuildContext context, {User? user}) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (context) => UserFormPage(user: user),
      ),
    );
  }

  static Future<T?> pushAddressForm<T>(BuildContext context,
      {required String userId, Address? address}) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (context) => AddressFormPage(userId: userId, address: address),
      ),
    );
  }

  static Future<T?> pushUserList<T>(BuildContext context) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      MaterialPageRoute(
        builder: (context) => const UserListPage(),
      ),
      (route) => false,
    );
  }

  static void pop(BuildContext context, [dynamic result]) {
    Navigator.of(context).pop(result);
  }

  static void popUntilRoot(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
