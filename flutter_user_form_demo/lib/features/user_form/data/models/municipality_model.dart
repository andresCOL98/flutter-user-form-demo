import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/municipality.dart';

part 'municipality_model.g.dart';

@JsonSerializable()
class MunicipalityModel extends Municipality {
  final DateTime createdAt;
  final DateTime updatedAt;

  const MunicipalityModel({
    required String id,
    required String name,
    required String code,
    required String departmentId,
    bool isActive = true,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
          id: id,
          name: name,
          code: code,
          departmentId: departmentId,
          isActive: isActive,
        );

  factory MunicipalityModel.fromJson(Map<String, dynamic> json) =>
      _$MunicipalityModelFromJson(json);

  Map<String, dynamic> toJson() => _$MunicipalityModelToJson(this);

  factory MunicipalityModel.fromMap(Map<String, dynamic> map) {
    return MunicipalityModel(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      departmentId: map['department_id'] as String,
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
      'department_id': departmentId,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory MunicipalityModel.fromEntity(Municipality municipality) {
    final now = DateTime.now();
    return MunicipalityModel(
      id: municipality.id,
      name: municipality.name,
      code: municipality.code,
      departmentId: municipality.departmentId,
      isActive: municipality.isActive,
      createdAt: now,
      updatedAt: now,
    );
  }

  Municipality toEntity() {
    return Municipality(
      id: id,
      name: name,
      code: code,
      departmentId: departmentId,
      isActive: isActive,
    );
  }

  MunicipalityModel copyWith({
    String? id,
    String? name,
    String? code,
    String? departmentId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MunicipalityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      departmentId: departmentId ?? this.departmentId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
