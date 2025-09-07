// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      streetAddress: json['streetAddress'] as String,
      streetAddress2: json['streetAddress2'] as String?,
      city: json['city'] as String,
      postalCode: json['postalCode'] as String,
      countryId: json['countryId'] as String,
      departmentId: json['departmentId'] as String,
      municipalityId: json['municipalityId'] as String,
      notes: json['notes'] as String?,
      isPrimary: json['isPrimary'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'streetAddress': instance.streetAddress,
      'streetAddress2': instance.streetAddress2,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'countryId': instance.countryId,
      'departmentId': instance.departmentId,
      'municipalityId': instance.municipalityId,
      'notes': instance.notes,
      'isPrimary': instance.isPrimary,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
