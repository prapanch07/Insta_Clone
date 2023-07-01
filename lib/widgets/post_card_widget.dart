import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/auths/firestore_auth.dart';
import 'package:insta_clone/constants/dimensions.dart';
import 'package:insta_clone/model/user_model.dart';
import 'package:insta_clone/provider/user_provider.dart';
import 'package:insta_clone/screens/screen_acc.dart';
import 'package:insta_clone/screens/screen_comments.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/custom_snackbar.dart';
import 'package:insta_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCardWidget extends StatefulWidget {
  final snap;
  const PostCardWidget({super.key, this.snap});

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  final homecommentController = TextEditingController();

  bool animating = false;
  int clength = 0;

  @override
  void initState() {
    super.initState();
    getcomments();
  }

  @override
  void dispose() {
    super.dispose();
    homecommentController;
  }

  getcomments() async {
    QuerySnapshot snapp = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postID'])
        .collection('comments')
        .get();
    final commentleng = snapp.docs.length;
    setState(() {
      clength = commentleng;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Users user = Provider.of<UserProvider>(context).getuser;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          children: [
            //header section

            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ScreenAccount(uid: widget.snap['uid']),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 16,
                ).copyWith(right: 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                        widget.snap['profileImage'],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.snap['username'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: ListView(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              children: [
                                'Delete',
                              ]
                                  .map(
                                    (e) => InkWell(
                                      onTap: () {
                                        if (widget.snap['uid'] ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid) {
                                          firestoreMethods().deletepost(
                                            widget.snap['postID'],
                                          );
                                          Navigator.of(context).pop();
                                        } else {
                                          customSnackbar(context,
                                              'sorry this is not your post');
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 16,
                                        ),
                                        child: Text(e),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.more_vert),
                    )
                  ],
                ),
              ),
            ),

// Image section

            GestureDetector(
              onDoubleTap: () async {
                setState(() {
                  animating = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .35,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.snap['postUrl'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: animating ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: LikeAnimation(
                      isAnimating: animating,
                      onEnd: () async {
                        await firestoreMethods().likes(
                          widget.snap['likes'],
                          widget.snap['uid'],
                          widget.snap['postID'],
                        );
                        setState(() {
                          animating = false;
                        });
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 110,
                      ),
                    ),
                  )
                ],
              ),
            ),

            // like section

            Row(
              children: [
                LikeAnimation(
                  smallLike: true,
                  isAnimating: widget.snap['likes'].contains(user.uid),
                  child: IconButton(
                    onPressed: () async {
                      await firestoreMethods().likes(
                        widget.snap['likes'],
                        widget.snap['uid'],
                        widget.snap['postID'],
                      );
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                          ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ScreenComments(
                          snap: widget.snap,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.comment_outlined,
                  ),
                ),
                IconButton(
                  onPressed: () => customSnackbar(context, unavailable),
                  icon: const Icon(Icons.send),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () => customSnackbar(context, unavailable),
                      icon: const Icon(
                        Icons.bookmark_outline_outlined,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // comment section

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${widget.snap['likes'].length} likes',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    width: double.infinity,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            text: "${widget.snap['username']} ",
                          ),
                          TextSpan(
                            text: widget.snap['caption'],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ScreenComments(snap: widget.snap),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        "view all $clength comments",
                        style: const TextStyle(
                            fontSize: 14, color: secondaryColor),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(
                          widget.snap['profileImage'],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) async {
                            await firestoreMethods().commentpost(
                                homecommentController.text,
                                user.photoUrl,
                                user.username,
                                user.uid,
                                widget.snap['postID']);
                            setState(() {
                              homecommentController.text = '';
                            });
                          },
                          controller: homecommentController,
                          decoration: const InputDecoration(
                            hintText: 'Add a comment...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            homecommentController.text = '❤';
                          });
                        },
                        child: const Icon(
                          Icons.favorite,
                          size: 15,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            homecommentController.text = '🤝';
                          });
                        },
                        child: Icon(
                          Icons.handshake,
                          size: 15,
                          color: Colors.amber[800],
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.add_circle_outline_sharp,
                          size: 15,
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style:
                          const TextStyle(fontSize: 10, color: secondaryColor),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
