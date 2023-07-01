import 'package:flutter/material.dart';
import 'package:insta_clone/screens/screen_story_view.dart';

class StoryCircleLimitedBox extends StatelessWidget {
  final snapshot;
  const StoryCircleLimitedBox({
    super.key,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ScreenStoryView(storysnap: snapshot),
          ));
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: const Color.fromARGB(36, 255, 254, 254),
              backgroundImage: NetworkImage(snapshot['storyUrl']),
            ),
            Text(
              snapshot['username'],
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

//// errlor
