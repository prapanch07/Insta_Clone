import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String username;
  final String email;
  final String password;
  final String uid;
  final String bio;
  final List followers;
  final List following;
  final String photoUrl;

  Users({
    required this.username,
    required this.email,
    required this.password,
    required this.uid,
    required this.bio,
    required this.followers,
    required this.following,
    required this.photoUrl,
  });

  Map<String, dynamic> tojson() => {
        "username": username,
        "email": email,
        "password": password,
        "uid": uid,
        "bio": bio,
        "followers": followers,
        "following": following,
        "photoUrl": photoUrl
      };

  static Users fromSnaptoUserm(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Users(
      username: snapshot['username'],
      email: snapshot['email'],
      password: snapshot['password'],
      uid: snapshot['uid'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      photoUrl: snapshot['photoUrl'],
    );
  }
}
