part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class LoadCountriesEvent extends LocationEvent {}

class LoadDepartmentsEvent extends LocationEvent {
  final String countryId;

  const LoadDepartmentsEvent({required this.countryId});

  @override
  List<Object?> get props => [countryId];
}

class LoadMunicipalitiesEvent extends LocationEvent {
  final String departmentId;

  const LoadMunicipalitiesEvent({required this.departmentId});

  @override
  List<Object?> get props => [departmentId];
}

class SelectCountryEvent extends LocationEvent {
  final Country country;

  const SelectCountryEvent({required this.country});

  @override
  List<Object?> get props => [country];
}

class SelectDepartmentEvent extends LocationEvent {
  final Department department;

  const SelectDepartmentEvent({required this.department});

  @override
  List<Object?> get props => [department];
}

class SelectMunicipalityEvent extends LocationEvent {
  final Municipality municipality;

  const SelectMunicipalityEvent({required this.municipality});

  @override
  List<Object?> get props => [municipality];
}

class ResetLocationEvent extends LocationEvent {}
