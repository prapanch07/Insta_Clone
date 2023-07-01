import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  final String username;
  final String caption;
  final String postID;
  final String uid;
  final String postUrl;
  final String profileImage;
  final datePublished;
  final likes;

  Posts({
    required this.username,
    required this.caption,
    required this.postID,
    required this.uid,
    required this.likes,
    required this.postUrl,
    required this.profileImage,
    required this.datePublished,
  });

  Map<String, dynamic> tojson() => {
        "username": username,
        "caption": caption,
        "postID": postID,
        "uid": uid,
        "likes": likes,
        "postUrl": postUrl,
        "profileImage": profileImage,
        "datePublished": datePublished
      };

  static Posts fromSnaptoUserm(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Posts(
      username: snapshot['username'],
      caption: snapshot['caption'],
      postID: snapshot['postID'],
      uid: snapshot['uid'],
      likes: snapshot['likes'],
      postUrl: snapshot['postUrl'],
      profileImage: snapshot['profileImage'],
      datePublished: snapshot['datePublished'],
    );
  }
}
