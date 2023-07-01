import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/widgets/custom_snackbar.dart';

import '../widgets/navigations.dart';

class ScreenStoryView extends StatefulWidget {
  final storysnap;
  const ScreenStoryView({super.key, required this.storysnap});

  @override
  State<ScreenStoryView> createState() => _ScreenStoryViewState();
}

class _ScreenStoryViewState extends State<ScreenStoryView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
           Future.delayed(Duration(seconds:10), () { 
          FirebaseFirestore.instance.collection('Stories').doc(widget.storysnap['storyID']).delete();  
        });
    Future.delayed(const Duration(seconds: 2), () {
      popNavigate(context);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => popNavigate(context),
            child: Stack(
              children: [
                Image(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  image: NetworkImage(
                    widget.storysnap['storyUrl'],
                  ),
                ),
                Positioned(
                  bottom: 25,
                  right: 20,
                  child: IconButton(
                    onPressed: () {
                      if (FirebaseAuth.instance.currentUser!.uid ==
                          widget.storysnap['uid']) {
                        FirebaseFirestore.instance
                            .collection('Stories')
                            .doc(widget.storysnap['storyID'])
                            .delete();
                        popNavigate(context);
                      } else {
                        customSnackbar(
                            context, 'This is not Your story to delete');
                      }
                    },
                    icon: const Icon(Icons.delete_forever_outlined),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
