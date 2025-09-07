import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_form_bloc/user_form_bloc.dart';
import '../../domain/entities/user.dart';

class UserFormLogic {
  /// Valida el formulario y envía los datos
  static void submitForm({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController emailController,
    required TextEditingController phoneNumberController,
    required DateTime? selectedDate,
    required bool isEditMode,
    User? originalUser,
  }) {
    if (formKey.currentState!.validate() && selectedDate != null) {
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final email = emailController.text.trim().isEmpty
          ? null
          : emailController.text.trim();
      final phoneNumber = phoneNumberController.text.trim().isEmpty
          ? null
          : phoneNumberController.text.trim();

      if (isEditMode && originalUser != null) {
        // Update existing user
        final updatedUser = originalUser.copyWith(
          firstName: firstName,
          lastName: lastName,
          dateOfBirth: selectedDate,
          email: email,
          phoneNumber: phoneNumber,
          updatedAt: DateTime.now(),
        );

        context.read<UserFormBloc>().add(UpdateUserEvent(user: updatedUser));
      } else {
        // Create new user
        context.read<UserFormBloc>().add(
              CreateUserEvent(
                firstName: firstName,
                lastName: lastName,
                dateOfBirth: selectedDate,
                email: email,
                phoneNumber: phoneNumber,
              ),
            );
      }
    } else if (selectedDate == null) {
      _showDateRequiredError(context);
    }
  }

  /// Pobla los campos del formulario con los datos del usuario
  static void populateFields({
    required User user,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController emailController,
    required TextEditingController phoneNumberController,
    required ValueSetter<DateTime?> setSelectedDate,
  }) {
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    emailController.text = user.email ?? '';
    phoneNumberController.text = user.phoneNumber ?? '';
    setSelectedDate(user.dateOfBirth);
  }

  /// Maneja los estados del BLoC
  static void handleBlocState(
    BuildContext context,
    UserFormState state,
    bool isEditMode,
  ) {
    if (state is UserFormSuccess) {
      _showSuccessMessage(context, isEditMode);
      Navigator.of(context).pop(true); // Return true to indicate success
    }

    if (state is UserFormError) {
      _showErrorMessage(context, state.message);
    }
  }

  /// Muestra mensaje de éxito
  static void _showSuccessMessage(BuildContext context, bool isEditMode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEditMode
            ? 'User updated successfully'
            : 'User created successfully'),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  /// Muestra mensaje de error
  static void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $message'),
        backgroundColor: Colors.red[700],
      ),
    );
  }

  /// Muestra error cuando no se ha seleccionado fecha
  static void _showDateRequiredError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Please select a date of birth'),
        backgroundColor: Colors.red[700],
      ),
    );
  }
}
