import 'package:equatable/equatable.dart';

class Municipality extends Equatable {
  final String id;

  final String name;

  final String code;

  final String departmentId;

  final bool isActive;

  const Municipality({
    required this.id,
    required this.name,
    required this.code,
    required this.departmentId,
    this.isActive = true,
  });

  Municipality copyWith({
    String? id,
    String? name,
    String? code,
    String? departmentId,
    bool? isActive,
  }) {
    return Municipality(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      departmentId: departmentId ?? this.departmentId,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object> get props => [id, name, code, departmentId, isActive];

  @override
  String toString() {
    return 'Municipality(id: $id, name: $name, code: $code, departmentId: $departmentId, isActive: $isActive)';
  }
}
