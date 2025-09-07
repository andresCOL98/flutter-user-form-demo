import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String id;

  final String streetAddress;

  final String? streetAddress2;

  final String city;

  final String postalCode;

  final String countryId;

  final String departmentId;

  final String municipalityId;

  final String? notes;

  final bool isPrimary;

  final bool isActive;

  final DateTime createdAt;

  final DateTime? updatedAt;

  const Address({
    required this.id,
    required this.streetAddress,
    this.streetAddress2,
    required this.city,
    required this.postalCode,
    required this.countryId,
    required this.departmentId,
    required this.municipalityId,
    this.notes,
    this.isPrimary = false,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  Address copyWith({
    String? id,
    String? streetAddress,
    String? streetAddress2,
    String? city,
    String? postalCode,
    String? countryId,
    String? departmentId,
    String? municipalityId,
    String? notes,
    bool? isPrimary,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Address(
      id: id ?? this.id,
      streetAddress: streetAddress ?? this.streetAddress,
      streetAddress2: streetAddress2 ?? this.streetAddress2,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      countryId: countryId ?? this.countryId,
      departmentId: departmentId ?? this.departmentId,
      municipalityId: municipalityId ?? this.municipalityId,
      notes: notes ?? this.notes,
      isPrimary: isPrimary ?? this.isPrimary,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get formattedAddress {
    final buffer = StringBuffer(streetAddress);

    if (streetAddress2 != null && streetAddress2!.isNotEmpty) {
      buffer.write(', $streetAddress2');
    }

    buffer.write(', $city');
    buffer.write(', $postalCode');

    if (notes != null && notes!.isNotEmpty) {
      buffer.write(' ($notes)');
    }

    return buffer.toString();
  }

  bool get isValid {
    return streetAddress.isNotEmpty &&
        city.isNotEmpty &&
        postalCode.isNotEmpty &&
        countryId.isNotEmpty &&
        departmentId.isNotEmpty &&
        municipalityId.isNotEmpty;
  }

  @override
  List<Object?> get props => [
        id,
        streetAddress,
        streetAddress2,
        city,
        postalCode,
        countryId,
        departmentId,
        municipalityId,
        notes,
        isPrimary,
        isActive,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Address(id: $id, streetAddress: $streetAddress, city: $city, '
        'postalCode: $postalCode, isPrimary: $isPrimary, isActive: $isActive)';
  }
}
