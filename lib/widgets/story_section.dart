import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/widgets/navigations.dart';
import 'package:insta_clone/widgets/story_circle_limited_box.dart';

class StorySection extends StatefulWidget {
  const StorySection({
    super.key,
    required this.userdata,
  });

  final Map userdata;

  @override
  State<StorySection> createState() => _StorySectionState();
}

class _StorySectionState extends State<StorySection> {
  DocumentSnapshot? storysnap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    widget.userdata['photoUrl'],
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 2,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: const Color.fromARGB(255, 5, 113, 236),
                    child: GestureDetector(
                      onTap: () =>
                          navigateToAddStrory(context, widget.userdata),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
       
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('Stories').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return LimitedBox(
                maxHeight: 70,
                maxWidth: snapshot.data!.docs.length * 100,
                child: ListView.builder( 
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return StoryCircleLimitedBox(
                      snapshot: snapshot.data!.docs[index],
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
