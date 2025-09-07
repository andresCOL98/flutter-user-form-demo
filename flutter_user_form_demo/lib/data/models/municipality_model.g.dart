// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'municipality_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MunicipalityModel _$MunicipalityModelFromJson(Map<String, dynamic> json) =>
    MunicipalityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      departmentId: json['department_id'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MunicipalityModelToJson(MunicipalityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'department_id': instance.departmentId,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
