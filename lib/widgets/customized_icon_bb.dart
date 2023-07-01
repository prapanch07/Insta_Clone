import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback func;
  final IconData icon;
  final double size;

  const CustomIconButton({super.key, required this.func, required this.icon, required this.size});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: func,
      child: Icon(
        icon,
        size: size,
      ),
    );
  }
}
