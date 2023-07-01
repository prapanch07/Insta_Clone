import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/custom_snackbar.dart';

import '../constants/dimensions.dart';
import '../widgets/message_bottom_nav_bar.dart';

class MessageScreen extends StatefulWidget {
  final String uid;
  const MessageScreen({super.key, required this.uid});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  var userData = {};
  bool isLoading = false;
  int post = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postsnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      userData = usersnap.data()!;
      post = postsnap.docs.length;
      setState(() {});
    } catch (e) {
      customSnackbar(context, 'Internal Error Occured while Fetching DATA');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              actions: [
                IconButton(
                  onPressed: () => customSnackbar(context, unavailable),
                  icon: const Icon(Icons.call),
                ),
                IconButton(
                  onPressed: () => customSnackbar(context, unavailable),
                  icon: const Icon(
                    Icons.videocam_outlined,
                    size: 30,
                  ),
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(userData['photoUrl']),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${userData['followers'].length} followers || $post posts',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(48, 158, 158, 158),
                    ),
                    child: const Center(
                      child: Text(
                        'View Profile',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: const MessageBottomNavBar(),
          );
  }
}
