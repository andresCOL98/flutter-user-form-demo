import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/country.dart';

part 'country_model.g.dart';

@JsonSerializable()
class CountryModel extends Country {
  final DateTime createdAt;
  final DateTime updatedAt;

  const CountryModel({
    required super.id,
    required super.name,
    required super.code,
    super.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CountryModelToJson(this);

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

  Country toEntity() {
    return Country(
      id: id,
      name: name,
      code: code,
      isActive: isActive,
    );
  }

  @override
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
