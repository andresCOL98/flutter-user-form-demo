// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
      id: json['id'] as String,
      streetAddress: json['street_address'] as String,
      streetAddress2: json['street_address_2'] as String?,
      city: json['city'] as String,
      postalCode: json['postal_code'] as String,
      countryId: json['country_id'] as String,
      departmentId: json['department_id'] as String,
      municipalityId: json['municipality_id'] as String,
      notes: json['notes'] as String?,
      isPrimary: json['is_primary'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'street_address': instance.streetAddress,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('street_address_2', instance.streetAddress2);
  val['city'] = instance.city;
  val['postal_code'] = instance.postalCode;
  val['country_id'] = instance.countryId;
  val['department_id'] = instance.departmentId;
  val['municipality_id'] = instance.municipalityId;
  writeNotNull('notes', instance.notes);
  val['is_primary'] = instance.isPrimary;
  val['is_active'] = instance.isActive;
  val['created_at'] = instance.createdAt.toIso8601String();
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}
