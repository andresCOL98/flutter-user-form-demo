import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/country.dart';
import '../../../domain/entities/department.dart';
import '../../../domain/entities/municipality.dart';
import '../../../domain/usecases/get_countries_usecase.dart';
import '../../../domain/usecases/get_departments_usecase.dart';
import '../../../domain/usecases/get_municipalities_usecase.dart';

part 'location_event.dart';
part 'location_state.dart';

@injectable
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCountriesUseCase getCountriesUseCase;
  final GetDepartmentsUseCase getDepartmentsUseCase;
  final GetMunicipalitiesUseCase getMunicipalitiesUseCase;

  LocationBloc({
    required this.getCountriesUseCase,
    required this.getDepartmentsUseCase,
    required this.getMunicipalitiesUseCase,
  }) : super(LocationInitial()) {
    on<LoadCountriesEvent>(_onLoadCountries);
    on<LoadDepartmentsEvent>(_onLoadDepartments);
    on<LoadMunicipalitiesEvent>(_onLoadMunicipalities);
    on<SelectCountryEvent>(_onSelectCountry);
    on<SelectDepartmentEvent>(_onSelectDepartment);
    on<SelectMunicipalityEvent>(_onSelectMunicipality);
    on<ResetLocationEvent>(_onResetLocation);
  }

  void _onLoadCountries(
      LoadCountriesEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());

    final result = await getCountriesUseCase();

    result.fold(
      (failure) => emit(LocationError(message: failure.message)),
      (countries) => emit(LocationLoaded(
        countries: countries,
        departments: [],
        municipalities: [],
      )),
    );
  }

  void _onLoadDepartments(
      LoadDepartmentsEvent event, Emitter<LocationState> emit) async {
    if (state is LocationLoaded) {
      final currentState = state as LocationLoaded;

      final params = GetDepartmentsParams(countryId: event.countryId);
      final result = await getDepartmentsUseCase(params);

      result.fold(
        (failure) => emit(LocationError(message: failure.message)),
        (departments) => emit(currentState.copyWith(
          departments: departments,
          municipalities: [], // Clear municipalities when country changes
          clearMunicipality: true,
        )),
      );
    }
  }

  void _onLoadMunicipalities(
      LoadMunicipalitiesEvent event, Emitter<LocationState> emit) async {
    if (state is LocationLoaded) {
      final currentState = state as LocationLoaded;

      final params = GetMunicipalitiesParams(departmentId: event.departmentId);
      final result = await getMunicipalitiesUseCase(params);

      result.fold(
        (failure) => emit(LocationError(message: failure.message)),
        (municipalities) => emit(currentState.copyWith(
          municipalities: municipalities,
        )),
      );
    }
  }

  void _onSelectCountry(
      SelectCountryEvent event, Emitter<LocationState> emit) async {
    if (state is LocationLoaded) {
      final currentState = state as LocationLoaded;

      emit(currentState.copyWith(
        selectedCountry: event.country,
        clearDepartment: true,
        clearMunicipality: true,
      ));

      // Automatically load departments for selected country
      add(LoadDepartmentsEvent(countryId: event.country.id));
    }
  }

  void _onSelectDepartment(
      SelectDepartmentEvent event, Emitter<LocationState> emit) async {
    if (state is LocationLoaded) {
      final currentState = state as LocationLoaded;

      emit(currentState.copyWith(
        selectedDepartment: event.department,
        clearMunicipality: true,
      ));

      // Automatically load municipalities for selected department
      add(LoadMunicipalitiesEvent(departmentId: event.department.id));
    }
  }

  void _onSelectMunicipality(
      SelectMunicipalityEvent event, Emitter<LocationState> emit) {
    if (state is LocationLoaded) {
      final currentState = state as LocationLoaded;

      emit(currentState.copyWith(
        selectedMunicipality: event.municipality,
      ));
    }
  }

  void _onResetLocation(ResetLocationEvent event, Emitter<LocationState> emit) {
    emit(LocationInitial());
  }
}
