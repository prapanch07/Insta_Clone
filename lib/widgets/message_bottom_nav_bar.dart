import 'package:flutter/material.dart';

class MessageBottomNavBar extends StatelessWidget {
  const MessageBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: const Color.fromARGB(118, 119, 117, 117),
          borderRadius: BorderRadius.circular(19),
        ),
        child:const Padding(
          padding:  EdgeInsets.symmetric(vertical: 5,horizontal: 2),
          child: Row(
            children: [
              CircleAvatar(radius: 20,
                backgroundColor: Color.fromARGB(255, 3, 136, 244),
                child: Icon(
                  Icons.camera_alt_outlined,color: Colors.white,
                ),
              ),
              SizedBox(width: 5,),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Message... '),
                ),
              ),
              Icon(Icons.mic_none_sharp),
              SizedBox(width: 5,),
              Icon(Icons.image_outlined),
              SizedBox(width: 5,)
          
            ],
          ),
        ),
      ),
    );
  }
}
