import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';
import '../widgets/custom_button.dart';

/// Widget para mostrar el estado de carga
class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}

/// Widget para mostrar el estado de error
class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CustomButton(
            onPressed: onRetry,
            text: 'Retry',
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ],
      ),
    );
  }
}

/// Widget para mostrar el estado vacío cuando no hay usuarios
class EmptyUsersState extends StatelessWidget {
  final VoidCallback onAddUser;
  final String title;
  final String subtitle;
  final String buttonText;

  const EmptyUsersState({
    super.key,
    required this.onAddUser,
    this.title = 'No users found',
    this.subtitle = 'Add your first user to get started',
    this.buttonText = 'Add First User',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: CustomButton(
              onPressed: onAddUser,
              text: buttonText,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              icon: Icons.add,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget para mostrar la lista de usuarios con RefreshIndicator
class UsersList extends StatelessWidget {
  final List<User> users;
  final Function(User) onUserTap;
  final Future<void> Function() onRefresh;

  const UsersList({
    super.key,
    required this.users,
    required this.onUserTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return EmptyUsersState(
        onAddUser: () {}, // Este será manejado por el parent
        title: 'No users found',
        subtitle: 'Add your first user using the + button',
        buttonText: 'Add User',
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      backgroundColor: Colors.white,
      color: Colors.black,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return UserListTile(
            user: user,
            onTap: () => onUserTap(user),
          );
        },
      ),
    );
  }
}

/// Widget para mostrar un usuario individual en la lista
class UserListTile extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const UserListTile({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.grey[850],
      child: ListTile(
        onTap: onTap,
        leading: UserAvatar(user: user),
        title: UserName(user: user),
        subtitle: UserDetails(user: user),
        trailing: const UserListTrailing(),
      ),
    );
  }
}

/// Widget para el avatar del usuario
class UserAvatar extends StatelessWidget {
  final User user;

  const UserAvatar({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: Text(
        user.initials,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Widget para el nombre del usuario
class UserName extends StatelessWidget {
  final User user;

  const UserName({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      user.fullName,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/// Widget para los detalles del usuario (email, teléfono, edad)
class UserDetails extends StatelessWidget {
  final User user;

  const UserDetails({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (user.email != null)
          Text(
            user.email!,
            style: TextStyle(color: Colors.grey[300]),
          ),
        if (user.phoneNumber != null)
          Text(
            user.phoneNumber!,
            style: TextStyle(color: Colors.grey[300]),
          ),
        Text(
          'Age: ${user.age} years',
          style: TextStyle(color: Colors.grey[400]),
        ),
      ],
    );
  }
}

/// Widget para el trailing icon de la lista
class UserListTrailing extends StatelessWidget {
  const UserListTrailing({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.chevron_right,
      color: Colors.grey,
    );
  }
}

/// AppBar customizado para la lista de usuarios
class UserListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAddUser;

  const UserListAppBar({
    super.key,
    required this.onAddUser,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Users',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.black,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: onAddUser,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
