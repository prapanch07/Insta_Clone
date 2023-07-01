import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/auths/firestore_auth.dart';

import 'package:insta_clone/model/user_model.dart';
import 'package:insta_clone/provider/user_provider.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import '../widgets/comment_card_widget.dart';

class ScreenComments extends StatefulWidget {
  const ScreenComments({super.key, required this.snap});
  final snap;

  @override
  State<ScreenComments> createState() => _ScreenCommentsState();
}

class _ScreenCommentsState extends State<ScreenComments> {
  final commentcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentcontroller;
  }

  @override
  Widget build(BuildContext context) {
    final Users user = Provider.of<UserProvider>(context).getuser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: mobileBackgroundColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postID'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => CommentCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              const SizedBox( 
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: commentcontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'comment as ${user.username}'),
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  await firestoreMethods().commentpost(
                      commentcontroller.text,
                      user.photoUrl,
                      user.username,
                      user.uid,
                      widget.snap['postID']);
                  setState(() {
                    commentcontroller.text = '';
                  });
                },
                child: const Text('Post'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
