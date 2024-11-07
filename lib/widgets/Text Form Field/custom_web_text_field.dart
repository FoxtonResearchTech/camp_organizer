import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomWebTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;


  CustomWebTextField({
    Key? key,
    required this.hintText,
    this.obscureText = false, this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        isDense: true,
        // Reduces the overall height of the TextField
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        labelText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlue, width: 1),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}