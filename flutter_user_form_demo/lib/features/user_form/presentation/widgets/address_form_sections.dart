import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/location_bloc.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/department.dart';
import '../../domain/entities/municipality.dart';
import 'location_dropdown.dart';
import 'custom_text_field.dart';

class AddressLocationSection extends StatelessWidget {
  const AddressLocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<LocationBloc, LocationState>(
            builder: (context, state) {
              if (state is LocationLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              }

              if (state is LocationError) {
                return Text(
                  'Error loading locations: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                );
              }

              if (state is LocationLoaded) {
                return Column(
                  children: [
                    LocationDropdown<Country>(
                      label: 'Country',
                      items: state.countries,
                      selectedItem: state.selectedCountry,
                      onChanged: (country) {
                        if (country != null) {
                          context.read<LocationBloc>().add(
                                SelectCountryEvent(country: country),
                              );
                        }
                      },
                      itemBuilder: (country) => country.name,
                      prefixIcon: Icons.flag,
                    ),
                    if (state.selectedCountry != null) ...[
                      const SizedBox(height: 16),
                      LocationDropdown<Department>(
                        label: 'Department',
                        items: state.departments,
                        selectedItem: state.selectedDepartment,
                        onChanged: (department) {
                          if (department != null) {
                            context.read<LocationBloc>().add(
                                  SelectDepartmentEvent(department: department),
                                );
                          }
                        },
                        itemBuilder: (department) => department.name,
                        prefixIcon: Icons.location_city,
                      ),
                    ],
                    if (state.selectedDepartment != null) ...[
                      const SizedBox(height: 16),
                      LocationDropdown<Municipality>(
                        label: 'Municipality',
                        items: state.municipalities,
                        selectedItem: state.selectedMunicipality,
                        onChanged: (municipality) {
                          if (municipality != null) {
                            context.read<LocationBloc>().add(
                                  SelectMunicipalityEvent(
                                      municipality: municipality),
                                );
                          }
                        },
                        itemBuilder: (municipality) => municipality.name,
                        prefixIcon: Icons.location_on,
                      ),
                    ],
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class AddressDetailsSection extends StatelessWidget {
  final TextEditingController streetController;
  final TextEditingController street2Controller;
  final TextEditingController cityController;
  final TextEditingController postalCodeController;
  final TextEditingController notesController;

  const AddressDetailsSection({
    super.key,
    required this.streetController,
    required this.street2Controller,
    required this.cityController,
    required this.postalCodeController,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Address Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: streetController,
            labelText: 'Street Address',
            prefixIcon: Icons.home,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Street address is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: street2Controller,
            labelText: 'Street Address 2 (Optional)',
            prefixIcon: Icons.home_outlined,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: cityController,
            labelText: 'City',
            prefixIcon: Icons.location_city,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'City is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: postalCodeController,
            labelText: 'Postal Code',
            prefixIcon: Icons.markunread_mailbox,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Postal code is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: notesController,
            labelText: 'Notes (Optional)',
            prefixIcon: Icons.note,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class AddressOptionsSection extends StatelessWidget {
  final bool isPrimary;
  final ValueChanged<bool> onPrimaryChanged;

  const AddressOptionsSection({
    super.key,
    required this.isPrimary,
    required this.onPrimaryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Options',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text(
              'Set as Primary Address',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'This will be the default address for the user',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
            value: isPrimary,
            onChanged: onPrimaryChanged,
            activeColor: Colors.white,
            activeTrackColor: Colors.grey[600],
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[800],
          ),
        ],
      ),
    );
  }
}
