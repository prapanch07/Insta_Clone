import 'package:cloud_firestore/cloud_firestore.dart';

class stories {
  final String username;

  final String storyID;
  final String uid;
  final String storyUrl;
  final String profilepic;

  stories({
    required this.storyUrl,
    required this.username,
    required this.storyID,
    required this.uid,
    required this.profilepic,
  });

  Map<String, dynamic> tojson() => {
        "username": username,
        "storyID": storyID,
        "uid": uid,
        "storyUrl": storyUrl,
        "profilepic": profilepic,
      };

  static stories fromSnaptoUserm(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return stories(
      storyUrl: snapshot['storyUrl'],
      username: snapshot['username'],
      storyID: snapshot['storyID'],
      uid: snapshot['uid'],
      profilepic: snapshot['profilepic'],
    );
  }
}
