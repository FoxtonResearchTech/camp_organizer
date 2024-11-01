import 'package:camp_organizer/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w500),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20), backgroundColor: AppColors.buttonBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}