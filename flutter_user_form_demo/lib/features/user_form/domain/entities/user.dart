import 'package:equatable/equatable.dart';

import 'address.dart';

class User extends Equatable {
  final String id;

  final String firstName;

  final String lastName;

  final DateTime dateOfBirth;

  final String? email;

  final String? phoneNumber;

  final List<Address> addresses;

  final bool isActive;

  final DateTime createdAt;

  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.email,
    this.phoneNumber,
    this.addresses = const [],
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  /// Creates a copy of this User with the given fields replaced with new values.
  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? email,
    String? phoneNumber,
    List<Address>? addresses,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      addresses: addresses ?? this.addresses,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Returns the user's full name.
  String get fullName => '$firstName $lastName';

  /// Returns the user's initials.
  String get initials {
    String firstInitial =
        firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    String lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  /// Returns the user's primary address if available.
  Address? get primaryAddress {
    try {
      return addresses.firstWhere((address) => address.isPrimary);
    } catch (e) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  /// Returns the user's age based on date of birth.
  int get age {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;

    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }

    return age;
  }

  /// Validates if the user has all required fields.
  bool get isValid {
    return firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        dateOfBirth.isBefore(DateTime.now()) &&
        age >= 0;
  }

  /// Returns the number of active addresses.
  int get activeAddressCount {
    return addresses.where((address) => address.isActive).length;
  }

  /// Checks if the user has a valid email format.
  bool get hasValidEmail {
    if (email == null || email!.isEmpty) return false;

    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email!);
  }

  /// Adds a new address to the user's address list.
  User addAddress(Address address) {
    final updatedAddresses = List<Address>.from(addresses)..add(address);
    return copyWith(
      addresses: updatedAddresses,
      updatedAt: DateTime.now(),
    );
  }

  /// Removes an address from the user's address list.
  User removeAddress(String addressId) {
    final updatedAddresses =
        addresses.where((address) => address.id != addressId).toList();

    return copyWith(
      addresses: updatedAddresses,
      updatedAt: DateTime.now(),
    );
  }

  /// Updates an existing address in the user's address list.
  User updateAddress(Address updatedAddress) {
    final addressIndex =
        addresses.indexWhere((address) => address.id == updatedAddress.id);

    if (addressIndex == -1) {
      return this; // Address not found, return unchanged user
    }

    final updatedAddresses = List<Address>.from(addresses);
    updatedAddresses[addressIndex] = updatedAddress;

    return copyWith(
      addresses: updatedAddresses,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        dateOfBirth,
        email,
        phoneNumber,
        addresses,
        isActive,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'User(id: $id, fullName: $fullName, email: $email, '
        'dateOfBirth: $dateOfBirth, addresses: ${addresses.length}, isActive: $isActive)';
  }
}
