import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/location_bloc/location_bloc.dart';
import '../../domain/entities/address.dart';
import '../../domain/usecases/add_address_usecase.dart';
import '../../../di/injection_container.dart';

class AddressFormLogic {
  static Future<void> submitForm({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String userId,
    required bool isEditMode,
    required Address? originalAddress,
    required TextEditingController streetController,
    required TextEditingController street2Controller,
    required TextEditingController cityController,
    required TextEditingController postalCodeController,
    required TextEditingController notesController,
    required bool isPrimary,
  }) async {
    if (!formKey.currentState!.validate()) return;

    final locationState = context.read<LocationBloc>().state;

    if (locationState is! LocationLoaded) return;

    if (locationState.selectedCountry == null ||
        locationState.selectedDepartment == null ||
        locationState.selectedMunicipality == null) {
      _showSnackBar(
        context,
        'Please select country, department and municipality',
        isError: true,
      );
      return;
    }

    try {
      final address = Address(
        id: isEditMode
            ? originalAddress!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        streetAddress: streetController.text.trim(),
        streetAddress2: street2Controller.text.trim(),
        city: cityController.text.trim(),
        postalCode: postalCodeController.text.trim(),
        countryId: locationState.selectedCountry!.id,
        departmentId: locationState.selectedDepartment!.id,
        municipalityId: locationState.selectedMunicipality!.id,
        isPrimary: isPrimary,
        isActive: true,
        notes: notesController.text.trim(),
        createdAt: isEditMode ? originalAddress!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final addAddressUseCase = getIt<AddAddressUseCase>();
      final params = AddAddressParams(userId: userId, address: address);
      final result = await addAddressUseCase(params);

      result.fold(
        (failure) => _showSnackBar(
          context,
          'Error: ${failure.message}',
          isError: true,
        ),
        (user) {
          _showSnackBar(
            context,
            isEditMode
                ? 'Address updated successfully'
                : 'Address added successfully',
            isError: false,
          );
          Navigator.of(context).pop(true);
        },
      );
    } catch (e) {
      _showSnackBar(
        context,
        'Error: ${e.toString()}',
        isError: true,
      );
    }
  }

  static void _showSnackBar(BuildContext context, String message,
      {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red[700] : Colors.green[700],
      ),
    );
  }

  static void populateFields({
    required Address address,
    required TextEditingController streetController,
    required TextEditingController street2Controller,
    required TextEditingController cityController,
    required TextEditingController postalCodeController,
    required TextEditingController notesController,
    required ValueSetter<bool> setIsPrimary,
  }) {
    streetController.text = address.streetAddress;
    street2Controller.text = address.streetAddress2 ?? '';
    cityController.text = address.city;
    postalCodeController.text = address.postalCode;
    notesController.text = address.notes ?? '';
    setIsPrimary(address.isPrimary);
  }
}
