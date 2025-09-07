import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_list_bloc/user_list_bloc.dart';
import '../../domain/entities/user.dart';
import '../navigation/app_router.dart';
import '../pages/user_detail_page.dart';
import 'user_list_sections.dart';

class UserListLogic {
  /// Inicializa la carga de usuarios
  static void initializeUsers(BuildContext context) {
    context.read<UserListBloc>().add(LoadUsersEvent());
  }

  /// Navega al formulario de usuario y maneja el resultado
  static Future<void> navigateToUserForm(
    BuildContext context,
    VoidCallback onUserCreated,
  ) async {
    final result = await AppNavigator.pushUserForm(context);
    if (result == true) {
      // Refresh the list if a user was created/updated
      onUserCreated();
    }
  }

  /// Refresca la lista de usuarios
  static void refreshUsers(BuildContext context) {
    context.read<UserListBloc>().add(RefreshUsersEvent());
  }

  /// Maneja el pull-to-refresh
  static Future<void> onRefresh(BuildContext context) async {
    context.read<UserListBloc>().add(RefreshUsersEvent());
    // Wait a bit to allow the refresh to complete
    await Future.delayed(const Duration(seconds: 1));
  }

  /// Navega a la página de detalle del usuario
  static void navigateToUserDetail(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailPage(user: user),
      ),
    );
  }

  /// Determina qué widget mostrar basado en el estado
  static Widget buildStateWidget({
    required UserListState state,
    required VoidCallback onRetry,
    required VoidCallback onAddUser,
    required Function(User) onUserTap,
    required Future<void> Function() onRefresh,
  }) {
    if (state is UserListInitial || state is UserListLoading) {
      return const LoadingState();
    }

    if (state is UserListError) {
      return ErrorState(
        message: state.message,
        onRetry: onRetry,
      );
    }

    if (state is UserListEmpty) {
      return EmptyUsersState(
        onAddUser: onAddUser,
        title: 'No users found',
        subtitle: 'Add your first user to get started',
        buttonText: 'Add First User',
      );
    }

    if (state is UserListLoaded) {
      return UsersList(
        users: state.users,
        onUserTap: onUserTap,
        onRefresh: onRefresh,
      );
    }

    return const SizedBox.shrink();
  }
}
