import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';
import '../../domain/entities/address.dart';

/// Widget modular para mostrar la información básica del usuario
class UserInfoSection extends StatelessWidget {
  final User user;

  const UserInfoSection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatarRow(user: user),
          const SizedBox(height: 20),
          UserInfoDetails(user: user),
        ],
      ),
    );
  }
}

/// Widget para mostrar el avatar y nombre del usuario
class UserAvatarRow extends StatelessWidget {
  final User user;

  const UserAvatarRow({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: Colors.grey[800],
          child: Text(
            user.initials,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Age: ${user.age} years',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Widget para mostrar los detalles del usuario (fecha nacimiento, email, etc.)
class UserInfoDetails extends StatelessWidget {
  final User user;

  const UserInfoDetails({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InfoRow(
          icon: Icons.cake,
          label: 'Date of Birth',
          value: _formatDate(user.dateOfBirth),
        ),
        if (user.email?.isNotEmpty == true) ...[
          const SizedBox(height: 12),
          InfoRow(
            icon: Icons.email,
            label: 'Email',
            value: user.email!,
          ),
        ],
        if (user.phoneNumber?.isNotEmpty == true) ...[
          const SizedBox(height: 12),
          InfoRow(
            icon: Icons.phone,
            label: 'Phone',
            value: user.phoneNumber!,
          ),
        ],
        const SizedBox(height: 12),
        InfoRow(
          icon: Icons.access_time,
          label: 'Created',
          value: _formatDate(user.createdAt),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Widget reutilizable para mostrar una fila de información con ícono
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey[400],
          size: 18,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Widget modular para la sección de direcciones
class AddressesSection extends StatelessWidget {
  final User user;
  final VoidCallback onAddAddress;

  const AddressesSection({
    super.key,
    required this.user,
    required this.onAddAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddressesHeader(onAddAddress: onAddAddress),
          const SizedBox(height: 16),
          AddressesContent(user: user),
        ],
      ),
    );
  }
}

/// Widget para el header de la sección de direcciones
class AddressesHeader extends StatelessWidget {
  final VoidCallback onAddAddress;

  const AddressesHeader({
    super.key,
    required this.onAddAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Addresses',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton.icon(
          onPressed: onAddAddress,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Add',
            style: TextStyle(color: Colors.white),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}

/// Widget para el contenido de direcciones (lista o estado vacío)
class AddressesContent extends StatelessWidget {
  final User user;

  const AddressesContent({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    if (user.addresses.isEmpty) {
      return const EmptyAddressesState();
    }

    return Column(
      children: user.addresses
          .map((address) => AddressTile(address: address))
          .toList(),
    );
  }
}

/// Widget para mostrar el estado vacío cuando no hay direcciones
class EmptyAddressesState extends StatelessWidget {
  const EmptyAddressesState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.location_off,
            color: Colors.grey[600],
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            'No addresses found',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap "Add" to create the first address',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget para mostrar una dirección individual
class AddressTile extends StatelessWidget {
  final Address address;

  const AddressTile({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        border: address.isPrimary
            ? Border.all(color: Colors.white, width: 2)
            : Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddressMainInfo(address: address),
          if (address.notes?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            AddressNotes(notes: address.notes!),
          ],
        ],
      ),
    );
  }
}

/// Widget para la información principal de la dirección
class AddressMainInfo extends StatelessWidget {
  final Address address;

  const AddressMainInfo({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          address.isPrimary ? Icons.home : Icons.location_on,
          color: address.isPrimary ? Colors.white : Colors.grey[400],
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            address.formattedAddress,
            style: TextStyle(
              color: address.isPrimary ? Colors.white : Colors.grey[300],
              fontSize: 14,
              fontWeight:
                  address.isPrimary ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
        if (address.isPrimary) const PrimaryAddressBadge(),
      ],
    );
  }
}

/// Widget para las notas de la dirección
class AddressNotes extends StatelessWidget {
  final String notes;

  const AddressNotes({
    super.key,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      notes,
      style: TextStyle(
        color: Colors.grey[500],
        fontSize: 12,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

/// Widget para el badge de dirección principal
class PrimaryAddressBadge extends StatelessWidget {
  const PrimaryAddressBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'PRIMARY',
        style: TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
