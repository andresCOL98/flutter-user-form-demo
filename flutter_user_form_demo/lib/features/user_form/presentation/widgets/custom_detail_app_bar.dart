import 'package:flutter/material.dart';

/// AppBar customizado con tema oscuro para las páginas de detalle
class CustomDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onEdit;
  final VoidCallback? onBack;

  const CustomDetailAppBar({
    super.key,
    required this.title,
    this.onEdit,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      ),
      actions: [
        if (onEdit != null)
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: onEdit,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
