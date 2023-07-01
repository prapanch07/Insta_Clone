import 'package:flutter/material.dart';
import 'package:insta_clone/constants/dimensions.dart';
import 'package:insta_clone/screens/screen_acc.dart';
import 'package:insta_clone/screens/screen_comments.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/custom_snackbar.dart';
import 'package:intl/intl.dart';

class ScreenPostViewAcc extends StatefulWidget {
  final snap;
  const ScreenPostViewAcc({Key? key, this.snap}) : super(key: key);

  @override
  State<ScreenPostViewAcc> createState() => _ScreenPostViewAccState();
}

class _ScreenPostViewAccState extends State<ScreenPostViewAcc> {
  bool islike = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: const Text('Post'),
        ),
        body: Padding(
          padding: size.width > 600
              ? const EdgeInsets.symmetric(horizontal: 10, vertical: 0)
              : const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                          widget.snap['profileImage'],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ScreenAccount(
                                    uid: widget.snap['uid'],
                                  )));
                        },
                        child: Text(
                          widget.snap['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width > 600 ? size.width / 2 : size.width,
                  height: size.width > 600 ? size.width / 2 : size.width,
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      widget.snap['postUrl'],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          islike = !islike;
                        });
                      },
                      child: islike == false
                          ? const Icon(
                              Icons.favorite_border,
                            )
                          : const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ScreenComments(
                              snap: widget.snap,
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.comment_outlined,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () => customSnackbar(context, unavailable),
                      child: const Icon(
                        Icons.send,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: size.width > 600
                          ? EdgeInsets.only(right: size.width / 2)
                          : const EdgeInsets.all(0),
                      child: InkWell(
                        onTap: () => customSnackbar(context, unavailable),
                        child: const Icon(
                          Icons.bookmark_outline_sharp,
                          size: 25,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    widget.snap['caption'],
                  ),
                ),
                Text(
                  DateFormat.yMMMd()
                      .format(widget.snap['datePublished'].toDate()),
                  style: const TextStyle(fontSize: 15, color: secondaryColor),
                ),
              ],
            ),
          ),
        ));
  }
}
