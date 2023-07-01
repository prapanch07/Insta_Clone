import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../utils/colors.dart';
import 'custom_snackbar.dart';

class HighlightSection extends StatelessWidget {
  const HighlightSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        const Text(
          'Story Highlights',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text('Keep your favorite stories on your profile'),
        const SizedBox(
          height: 5,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: mobileBackgroundColor,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(500),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                      onPressed: () => customSnackbar(context, unavailable),
                    ),
                  ),
                  const Text('New')
                ],
              ),
              Padding( 
                padding: const EdgeInsets.all(4.0),
                child: Container( 
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration( 
                    color: const Color.fromARGB(40, 158, 158, 158),
                    borderRadius: BorderRadius.circular(500),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(40, 158, 158, 158),
                    borderRadius: BorderRadius.circular(500),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(40, 158, 158, 158),
                    borderRadius: BorderRadius.circular(500),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(40, 158, 158, 158),
                    borderRadius: BorderRadius.circular(500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
