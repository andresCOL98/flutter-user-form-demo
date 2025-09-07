import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String id;

  final String name;

  final String code;

  final bool isActive;

  const Country({
    required this.id,
    required this.name,
    required this.code,
    this.isActive = true,
  });

  Country copyWith({
    String? id,
    String? name,
    String? code,
    bool? isActive,
  }) {
    return Country(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object> get props => [id, name, code, isActive];

  @override
  String toString() {
    return 'Country(id: $id, name: $name, code: $code, isActive: $isActive)';
  }
}
