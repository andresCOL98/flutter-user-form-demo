part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final List<Country> countries;
  final List<Department> departments;
  final List<Municipality> municipalities;
  final Country? selectedCountry;
  final Department? selectedDepartment;
  final Municipality? selectedMunicipality;

  const LocationLoaded({
    required this.countries,
    required this.departments,
    required this.municipalities,
    this.selectedCountry,
    this.selectedDepartment,
    this.selectedMunicipality,
  });

  @override
  List<Object?> get props => [
        countries,
        departments,
        municipalities,
        selectedCountry,
        selectedDepartment,
        selectedMunicipality,
      ];

  LocationLoaded copyWith({
    List<Country>? countries,
    List<Department>? departments,
    List<Municipality>? municipalities,
    Country? selectedCountry,
    Department? selectedDepartment,
    Municipality? selectedMunicipality,
    bool clearDepartment = false,
    bool clearMunicipality = false,
  }) {
    return LocationLoaded(
      countries: countries ?? this.countries,
      departments: departments ?? this.departments,
      municipalities: municipalities ?? this.municipalities,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedDepartment: clearDepartment
          ? null
          : (selectedDepartment ?? this.selectedDepartment),
      selectedMunicipality: clearMunicipality
          ? null
          : (selectedMunicipality ?? this.selectedMunicipality),
    );
  }
}

class LocationError extends LocationState {
  final String message;

  const LocationError({required this.message});

  @override
  List<Object?> get props => [message];
}
