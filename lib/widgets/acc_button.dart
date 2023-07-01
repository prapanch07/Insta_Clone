import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  const AccountButton(
      {super.key,
      required this.function,
      required this.label,
      required this.backgroundColor});

  final VoidCallback function;
  final String label;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: backgroundColor,
      ),
      child: TextButton(
        onPressed: function,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13.3,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
