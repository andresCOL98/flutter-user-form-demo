import 'package:json_annotation/json_annotation.dart';
import '../../features/user_form/domain/entities/address.dart';

part 'address_model.g.dart';

/// Data model for Address entity with JSON serialization support
@JsonSerializable()
class AddressModel extends Address {
  const AddressModel({
    required String id,
    required String streetAddress,
    String? streetAddress2,
    required String city,
    required String postalCode,
    required String countryId,
    required String departmentId,
    required String municipalityId,
    String? notes,
    bool isPrimary = false,
    bool isActive = true,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          streetAddress: streetAddress,
          streetAddress2: streetAddress2,
          city: city,
          postalCode: postalCode,
          countryId: countryId,
          departmentId: departmentId,
          municipalityId: municipalityId,
          notes: notes,
          isPrimary: isPrimary,
          isActive: isActive,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Creates an AddressModel from JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  /// Converts AddressModel to JSON
  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  /// Creates an AddressModel from database map
  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] as String,
      streetAddress: map['street_address'] as String,
      streetAddress2: map['street_address_2'] as String?,
      city: map['city'] as String,
      postalCode: map['postal_code'] as String,
      countryId: map['country_id'] as String,
      departmentId: map['department_id'] as String,
      municipalityId: map['municipality_id'] as String,
      notes: map['notes'] as String?,
      isPrimary: (map['is_primary'] as int?) == 1,
      isActive: (map['is_active'] as int?) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  /// Converts AddressModel to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'street_address': streetAddress,
      'street_address_2': streetAddress2,
      'city': city,
      'postal_code': postalCode,
      'country_id': countryId,
      'department_id': departmentId,
      'municipality_id': municipalityId,
      'notes': notes,
      'is_primary': isPrimary ? 1 : 0,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Creates an AddressModel from domain entity
  factory AddressModel.fromEntity(Address address) {
    return AddressModel(
      id: address.id,
      streetAddress: address.streetAddress,
      streetAddress2: address.streetAddress2,
      city: address.city,
      postalCode: address.postalCode,
      countryId: address.countryId,
      departmentId: address.departmentId,
      municipalityId: address.municipalityId,
      notes: address.notes,
      isPrimary: address.isPrimary,
      isActive: address.isActive,
      createdAt: address.createdAt,
      updatedAt: address.updatedAt,
    );
  }

  /// Converts to domain entity
  Address toEntity() {
    return Address(
      id: id,
      streetAddress: streetAddress,
      streetAddress2: streetAddress2,
      city: city,
      postalCode: postalCode,
      countryId: countryId,
      departmentId: departmentId,
      municipalityId: municipalityId,
      notes: notes,
      isPrimary: isPrimary,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Creates a copy with updated fields
  AddressModel copyWith({
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
    return AddressModel(
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
}
