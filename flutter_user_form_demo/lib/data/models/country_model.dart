import 'package:json_annotation/json_annotation.dart';
import '../../features/user_form/domain/entities/country.dart';

part 'country_model.g.dart';

/// Data model for Country entity with JSON serialization support
@JsonSerializable()
class CountryModel extends Country {
  final DateTime createdAt;
  final DateTime updatedAt;

  const CountryModel({
    required String id,
    required String name,
    required String code,
    bool isActive = true,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
          id: id,
          name: name,
          code: code,
          isActive: isActive,
        );

  /// Creates a CountryModel from JSON
  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  /// Converts CountryModel to JSON
  Map<String, dynamic> toJson() => _$CountryModelToJson(this);

  /// Creates a CountryModel from database map
  factory CountryModel.fromMap(Map<String, dynamic> map) {
    return CountryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      isActive: (map['is_active'] as int?) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Converts CountryModel to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Creates a CountryModel from domain entity
  factory CountryModel.fromEntity(Country country) {
    final now = DateTime.now();
    return CountryModel(
      id: country.id,
      name: country.name,
      code: country.code,
      isActive: country.isActive,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Converts to domain entity
  Country toEntity() {
    return Country(
      id: id,
      name: name,
      code: code,
      isActive: isActive,
    );
  }

  /// Creates a copy with updated fields
  CountryModel copyWith({
    String? id,
    String? name,
    String? code,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CountryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
