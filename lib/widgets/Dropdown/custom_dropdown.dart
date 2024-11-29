import 'package:camp_organizer/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatelessWidget {
  final String labelText;
  final IconData? icon;
  final List<String> items;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownFormField({
    Key? key,
    required this.labelText,
    this.icon,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: AppColors.textBlue,
          fontFamily: 'LeagueSpartan',
        ),
        prefixIcon:
            icon != null ? Icon(icon, color: AppColors.primaryBlue) : null,
        filled: true,
        fillColor: AppColors.lightBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.accentBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
