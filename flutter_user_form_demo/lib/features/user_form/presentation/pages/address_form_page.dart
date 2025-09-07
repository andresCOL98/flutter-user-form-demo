import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/location_bloc.dart';
import '../../domain/entities/address.dart';
import '../widgets/address_form_sections.dart';
import '../widgets/address_form_logic.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_overlay.dart';

class AddressFormPage extends StatefulWidget {
  final String userId;
  final Address? address; // null for create, Address instance for edit

  const AddressFormPage({
    super.key,
    required this.userId,
    this.address,
  });

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _street2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isPrimary = false;
  bool _isEditMode = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.address != null;

    if (_isEditMode) {
      _populateFields();
    }

    // Load countries when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationBloc>().add(LoadCountriesEvent());
    });
  }

  void _populateFields() {
    if (widget.address != null) {
      AddressFormLogic.populateFields(
        address: widget.address!,
        streetController: _streetController,
        street2Controller: _street2Controller,
        cityController: _cityController,
        postalCodeController: _postalCodeController,
        notesController: _notesController,
        setIsPrimary: (value) => setState(() => _isPrimary = value),
      );
    }
  }

  Future<void> _submitForm() async {
    setState(() => _isLoading = true);

    try {
      await AddressFormLogic.submitForm(
        context: context,
        formKey: _formKey,
        userId: widget.userId,
        isEditMode: _isEditMode,
        originalAddress: widget.address,
        streetController: _streetController,
        street2Controller: _street2Controller,
        cityController: _cityController,
        postalCodeController: _postalCodeController,
        notesController: _notesController,
        isPrimary: _isPrimary,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditMode ? 'Edit Address' : 'Add Address'),
        ),
        body: BlocListener<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state is LocationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.red[700],
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Location Section
                    AddressLocationSection(),

                    const SizedBox(height: 24),

                    // Address Details Section
                    AddressDetailsSection(
                      streetController: _streetController,
                      street2Controller: _street2Controller,
                      cityController: _cityController,
                      postalCodeController: _postalCodeController,
                      notesController: _notesController,
                    ),

                    const SizedBox(height: 24),

                    // Options Section
                    AddressOptionsSection(
                      isPrimary: _isPrimary,
                      onPrimaryChanged: (value) =>
                          setState(() => _isPrimary = value),
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    CustomButton(
                      text: _isEditMode ? 'Update Address' : 'Add Address',
                      onPressed: _submitForm,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _streetController.dispose();
    _street2Controller.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
