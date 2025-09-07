import 'package:flutter/material.dart';

import '../widgets/custom_text_field.dart';

/// Widget modular para la sección de información personal
class PersonalInformationSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final bool enabled;

  const PersonalInformationSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.selectedDate,
    required this.onDateSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: 'Personal Information',
      children: [
        CustomTextField(
          controller: firstNameController,
          labelText: 'First Name',
          prefixIcon: Icons.person,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'First name is required';
            }
            if (value.trim().length < 2) {
              return 'First name must be at least 2 characters';
            }
            return null;
          },
          enabled: enabled,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: lastNameController,
          labelText: 'Last Name',
          prefixIcon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Last name is required';
            }
            if (value.trim().length < 2) {
              return 'Last name must be at least 2 characters';
            }
            return null;
          },
          enabled: enabled,
        ),
        const SizedBox(height: 16),
        DateField(
          selectedDate: selectedDate,
          onDateSelected: onDateSelected,
          enabled: enabled,
        ),
      ],
    );
  }
}

/// Widget modular para la sección de información de contacto
class ContactInformationSection extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController phoneNumberController;
  final bool enabled;

  const ContactInformationSection({
    super.key,
    required this.emailController,
    required this.phoneNumberController,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: 'Contact Information (Optional)',
      children: [
        CustomTextField(
          controller: emailController,
          labelText: 'Email',
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value != null && value.trim().isNotEmpty) {
              final emailRegExp = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              );
              if (!emailRegExp.hasMatch(value.trim())) {
                return 'Please enter a valid email address';
              }
            }
            return null;
          },
          enabled: enabled,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: phoneNumberController,
          labelText: 'Phone Number',
          prefixIcon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value != null && value.trim().isNotEmpty) {
              final phoneRegExp = RegExp(r'^\+?[\d\s\-\(\)]+$');
              if (!phoneRegExp.hasMatch(value.trim())) {
                return 'Please enter a valid phone number';
              }
            }
            return null;
          },
          enabled: enabled,
        ),
      ],
    );
  }
}

/// Widget reutilizable para secciones del formulario
class FormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const FormSection({
    super.key,
    required this.title,
    required this.children,
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
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

/// Widget para selección de fecha de nacimiento
class DateField extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final bool enabled;

  const DateField({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? () => _selectDate(context) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: enabled ? Colors.grey[850] : Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: Colors.grey[400],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedDate != null
                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                    : 'Select Date of Birth',
                style: TextStyle(
                  color: selectedDate != null ? Colors.white : Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ??
          DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              surface: Color(0xFF1E1E1E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }
}
