import 'package:json_annotation/json_annotation.dart';
import '../../features/user_form/domain/entities/user.dart';
import '../../features/user_form/domain/entities/address.dart';

part 'user_model.g.dart';

/// Data model for User entity with JSON serialization support
@JsonSerializable()
class UserModel extends User {
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  final List<Address> addresses;

  const UserModel({
    required String id,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    String? email,
    String? phoneNumber,
    this.addresses = const [],
    bool isActive = true,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          dateOfBirth: dateOfBirth,
          email: email,
          phoneNumber: phoneNumber,
          addresses: addresses,
          isActive: isActive,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Creates a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Converts UserModel to JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Creates a UserModel from database map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      dateOfBirth: DateTime.parse(map['date_of_birth'] as String),
      email: map['email'] as String?,
      phoneNumber: map['phone_number'] as String?,
      addresses: const [], // Addresses are loaded separately
      isActive: (map['is_active'] as int?) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  /// Converts UserModel to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'email': email,
      'phone_number': phoneNumber,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Creates a UserModel from domain entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      dateOfBirth: user.dateOfBirth,
      email: user.email,
      phoneNumber: user.phoneNumber,
      addresses: user.addresses,
      isActive: user.isActive,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  /// Converts to domain entity
  User toEntity() {
    return User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      email: email,
      phoneNumber: phoneNumber,
      addresses: addresses,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Creates a copy with updated fields
  UserModel copyWith({
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
    return UserModel(
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
}
