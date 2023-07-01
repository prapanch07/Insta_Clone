import 'package:flutter/material.dart';

class CustomTextFeild extends StatelessWidget {
  const CustomTextFeild(
      {super.key,
      required this.hintText,
      required this.keyboardtype,
       this.obscureText = false,
      required this.controller});

  final String hintText;
  final TextInputType keyboardtype;
  final bool obscureText;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextFormField(
   textInputAction: TextInputAction.next,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true, 
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: keyboardtype,
      obscureText: obscureText,
    );
  }
}
