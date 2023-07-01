import 'package:flutter/material.dart';

class FFStatusWidget extends StatelessWidget {
  const FFStatusWidget(
      {super.key, required this.label, required this.FFStatus});
  final String label;
  final String FFStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          FFStatus,
          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 22),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
