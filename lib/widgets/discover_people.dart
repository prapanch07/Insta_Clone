import 'package:flutter/material.dart';
import 'package:insta_clone/screens/screen_acc.dart';

import 'acc_button.dart';

class DiscoverPeopleWidget extends StatefulWidget {
  final snap;

  const DiscoverPeopleWidget({
    super.key,
    required this.snap,
  });

  @override
  State<DiscoverPeopleWidget> createState() => _DiscoverPeopleWidgetState();
}

class _DiscoverPeopleWidgetState extends State<DiscoverPeopleWidget> {
  bool isfollowing = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 0,
        right: 5,
        top: 5,
        bottom: 0,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ScreenAccount(
                uid: widget.snap['uid'],
              ),
            ),
          );
        },
        child: Container(
          height: 150,
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: const Color.fromARGB(117, 82, 79, 79),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(widget.snap['photoUrl']),
              ),
              Text(
                widget.snap['username'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isfollowing == false
                      ? AccountButton(
                          function: () {
                            setState(() {
                              isfollowing = true;
                            });
                          },
                          label: 'follow', 
                          backgroundColor: Colors.blue,
                        )
                      : AccountButton(
                          function: () {
                            setState(() {
                              isfollowing = false;
                            });
                          },
                          label: 'unfollow',
                          backgroundColor: const Color.fromARGB(
                                          40, 158, 158, 158),
                        ))
            ],
          ),
        ),
      ),
    );
  }
}
