import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_form_bloc.dart';
import '../../domain/entities/user.dart';
import '../widgets/user_form_sections.dart';
import '../widgets/user_form_logic.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_detail_app_bar.dart';

class UserFormPage extends StatefulWidget {
  final User? user; // null for create, User instance for edit

  const UserFormPage({
    super.key,
    this.user,
  });

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  DateTime? _selectedDate;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.user != null;

    if (_isEditMode) {
      _populateFields();
    }
  }

  void _populateFields() {
    UserFormLogic.populateFields(
      user: widget.user!,
      firstNameController: _firstNameController,
      lastNameController: _lastNameController,
      emailController: _emailController,
      phoneNumberController: _phoneNumberController,
      setSelectedDate: (date) => setState(() => _selectedDate = date),
    );
  }

  void _submitForm() {
    UserFormLogic.submitForm(
      context: context,
      formKey: _formKey,
      firstNameController: _firstNameController,
      lastNameController: _lastNameController,
      emailController: _emailController,
      phoneNumberController: _phoneNumberController,
      selectedDate: _selectedDate,
      isEditMode: _isEditMode,
      originalUser: widget.user,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomDetailAppBar(
        title: _isEditMode ? 'Edit User' : 'Create User',
      ),
      body: BlocListener<UserFormBloc, UserFormState>(
        listener: (context, state) {
          UserFormLogic.handleBlocState(context, state, _isEditMode);
        },
        child: BlocBuilder<UserFormBloc, UserFormState>(
          builder: (context, state) {
            final isLoading = state is UserFormLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Personal Information Section
                    PersonalInformationSection(
                      firstNameController: _firstNameController,
                      lastNameController: _lastNameController,
                      selectedDate: _selectedDate,
                      onDateSelected: (date) => setState(() => _selectedDate = date),
                      enabled: !isLoading,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Contact Information Section
                    ContactInformationSection(
                      emailController: _emailController,
                      phoneNumberController: _phoneNumberController,
                      enabled: !isLoading,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Submit Button
                    CustomButton(
                      onPressed: isLoading ? null : _submitForm,
                      text: _isEditMode ? 'Update User' : 'Create User',
                      isLoading: isLoading,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}
