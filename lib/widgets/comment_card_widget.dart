import 'package:flutter/material.dart';
import 'package:insta_clone/widgets/custom_snackbar.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({
    super.key,
    required this.snap,
  });

  final snap;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool iscommentlike = false;
  int countLike = 0;
  var commentDate = {};
  String day = 'hei';

  Future<String> formatDateToDaysAgo(String date) async {
    DateTime dates = DateFormat("MMM dd, yyyy").parse(date);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dates);

    if (difference.inDays == 0) {
      return "Today";
    } else {
      return "${difference.inDays}d ";
    }
  }

  value() async {
    String days = await formatDateToDaysAgo(
        DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()));

    setState(() {
      day = days;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap['profilePic'],
            ),
            radius: 18,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${widget.snap['name']}  ',
                        // style: TextStyle(),
                      ),
                      TextSpan(
                        text: ' $day ',
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  widget.snap['text'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    customSnackbar(
                        context, 'This feature is not available now');
                  },
                  child: const Text(
                    'reply',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.grey,
                      fontSize: 13.3,
                    ),
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      if (iscommentlike == false) {
                        iscommentlike = true;
                        countLike++;
                      } else {
                        iscommentlike = false;
                        countLike--;
                      }
                    });
                  },
                  child: iscommentlike == false
                      ? const Icon(
                          Icons.favorite_border,
                        )
                      : const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )),
              const SizedBox(
                height: 2,
              ),
              countLike == 0
                  ? const Text('')
                  : Text(
                      '$countLike',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        decoration: TextDecoration.none,
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }
}
