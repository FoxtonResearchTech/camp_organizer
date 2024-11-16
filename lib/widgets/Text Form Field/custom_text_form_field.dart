import 'package:camp_organizer/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final VoidCallback? onTap; // Add onTap parameter
  final void Function(String?)? onSaved; // Add onSaved property

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    this.icon,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onTap, // Initialize onTap
    this.onSaved, // Initialize onSaved

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      keyboardType: keyboardType,
      onTap: onTap, // Set the onTap callback here
      onSaved: onSaved, // Set the onSaved callback
      readOnly: onTap != null, // Make the field read-only if onTap is set
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: AppColors.textBlue), // Updated color for label
        prefixIcon: icon != null ? Icon(icon, color: AppColors.primaryBlue) : null, // Updated icon color
        filled: false,
        fillColor: AppColors.lightBlue, // Updated background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.accentBlue), // Accent color for the outline border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryBlue, width: 2), // Focus color
        ),
      ),
    );
  }
}
