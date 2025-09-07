import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/department.dart';

part 'department_model.g.dart';

@JsonSerializable()
class DepartmentModel extends Department {
  final DateTime createdAt;
  final DateTime updatedAt;

  const DepartmentModel({
    required String id,
    required String name,
    required String code,
    required String countryId,
    bool isActive = true,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
          id: id,
          name: name,
          code: code,
          countryId: countryId,
          isActive: isActive,
        );

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentModelToJson(this);

  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      countryId: map['country_id'] as String,
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
      'country_id': countryId,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory DepartmentModel.fromEntity(Department department) {
    final now = DateTime.now();
    return DepartmentModel(
      id: department.id,
      name: department.name,
      code: department.code,
      countryId: department.countryId,
      isActive: department.isActive,
      createdAt: now,
      updatedAt: now,
    );
  }

  Department toEntity() {
    return Department(
      id: id,
      name: name,
      code: code,
      countryId: countryId,
      isActive: isActive,
    );
  }

  DepartmentModel copyWith({
    String? id,
    String? name,
    String? code,
    String? countryId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DepartmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      countryId: countryId ?? this.countryId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
