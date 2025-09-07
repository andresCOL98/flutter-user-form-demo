import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/address.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel extends Address {
  const AddressModel({
    required super.id,
    required super.userId,
    required super.streetAddress,
    super.streetAddress2,
    required super.city,
    required super.postalCode,
    required super.countryId,
    required super.departmentId,
    required super.municipalityId,
    super.notes,
    super.isPrimary,
    super.isActive,
    required super.createdAt,
    super.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      streetAddress: map['street'] as String,
      streetAddress2: map['street2'] as String?,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'street': streetAddress,
      'street2': streetAddress2,
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

  factory AddressModel.fromEntity(Address address) {
    return AddressModel(
      id: address.id,
      userId: address.userId,
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

  Address toEntity() {
    return Address(
      id: id,
      userId: userId,
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

  @override
  AddressModel copyWith({
    String? id,
    String? userId,
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
      userId: userId ?? this.userId,
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
