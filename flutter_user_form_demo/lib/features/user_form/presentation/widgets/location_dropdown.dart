import 'package:flutter/material.dart';

class LocationDropdown<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemBuilder;
  final IconData? prefixIcon;

  const LocationDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.itemBuilder,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<T>(
        value: selectedItem,
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              itemBuilder(item),
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          prefixIcon: Icon(
            prefixIcon ?? Icons.location_on,
            color: Colors.grey[400],
          ),
        ),
        dropdownColor: Colors.grey[850],
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (value == null) {
            return 'Please select a $label';
          }
          return null;
        },
      ),
    );
  }
}
