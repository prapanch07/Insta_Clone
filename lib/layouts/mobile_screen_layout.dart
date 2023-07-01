import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/screen_acc.dart';
import '../screens/screen_add_post.dart';
import '../screens/screen_home.dart';
import '../screens/screen_reels.dart';
import '../screens/screen_search.dart';
import '../utils/colors.dart';

class MobileScreenLayout extends StatefulWidget {
  MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
// bottom nav bar logic

    final _pages = [
      const Screenhome(),
      const ScreenSearch(),
      const ScreenAddPost(),
      const ScreenReels(),
      ScreenAccount(
        uid: FirebaseAuth.instance.currentUser!.uid,
      )
    ]; 

    return Scaffold( 
      body: _pages[_index],  
      // body:  ScreenAccount(
      //   uid: FirebaseAuth.instance.currentUser!.uid,
      // ),
     
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _index = index; 
            // AuthMethods().signout(); 
          });
        },
        backgroundColor: mobileBackgroundColor, 
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: secondaryColor,
        selectedItemColor: primaryColor,
        currentIndex: _index,
        items: const [ 
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '',
          )
        ],
      ),
    );
  }
}
