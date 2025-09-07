import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';
import '../widgets/user_detail_sections.dart';
import '../widgets/user_detail_logic.dart';
import '../widgets/custom_detail_app_bar.dart';
import '../widgets/loading_overlay.dart';

class UserDetailPage extends StatefulWidget {
  final User user;

  const UserDetailPage({
    super.key,
    required this.user,
  });

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    UserDetailLogic.initialize();
    _currentUser = widget.user;
    _loadUserWithAddresses();
  }

  Future<void> _loadUserWithAddresses() async {
    setState(() => _isLoading = true);

    final user = await UserDetailLogic.loadUserWithAddresses(widget.user.id);

    if (mounted) {
      setState(() {
        _currentUser = user ?? widget.user;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleAddAddress() async {
    final success = await UserDetailLogic.addAddress(context, widget.user.id);

    // Si se agregó una dirección exitosamente, recargar el usuario
    if (success) {
      _loadUserWithAddresses();
    }
  }

  void _handleEditUser() {
    UserDetailLogic.editUser(context);
  }

  @override
  Widget build(BuildContext context) {
    final displayUser = _currentUser ?? widget.user;

    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomDetailAppBar(
          title: displayUser.fullName,
          onEdit: _handleEditUser,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfoSection(user: displayUser),
              const SizedBox(height: 24),
              AddressesSection(
                user: displayUser,
                onAddAddress: _handleAddAddress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
