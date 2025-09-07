import 'package:equatable/equatable.dart';

class Department extends Equatable {
  final String id;

  final String name;

  final String code;

  final String countryId;

  final bool isActive;

  const Department({
    required this.id,
    required this.name,
    required this.code,
    required this.countryId,
    this.isActive = true,
  });

  Department copyWith({
    String? id,
    String? name,
    String? code,
    String? countryId,
    bool? isActive,
  }) {
    return Department(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      countryId: countryId ?? this.countryId,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object> get props => [id, name, code, countryId, isActive];

  @override
  String toString() {
    return 'Department(id: $id, name: $name, code: $code, countryId: $countryId, isActive: $isActive)';
  }
}
