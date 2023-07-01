import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:insta_clone/auths/storage.dart';
import 'package:insta_clone/model/post_model.dart';
import 'package:insta_clone/model/story_model.dart';
import 'package:uuid/uuid.dart';

class firestoreMethods {
  final _firestore = FirebaseFirestore.instance;

  //upload Post

  Future<String> uploadpost(
    String caption,
    String uid,
    Uint8List file,
    String username,
    String profileImage,
  ) async {
    String res = 'error occured';

    try {
      String photoUrl =
          await StorageMethods().uploadImageToString('Posts', file, true);
      String postId = const Uuid().v1();
      Posts post = Posts(
        username: username,
        caption: caption,
        postID: postId,
        uid: uid,
        likes: [],
        postUrl: photoUrl,
        profileImage: profileImage,
        datePublished: DateTime.now(),
      );
      _firestore.collection('posts').doc(postId).set(
            post.tojson(),
          );
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // upload story

  Future<String> uploadstory(
    String username,
    String uid,
    String profilePic,
    Uint8List file,
  ) async {
    String result = 'error required';
    try {
      String storyUrl =
          await StorageMethods().uploadImageToString('stories', file, true);
      String storyID = const Uuid().v1();
      stories story = stories(
        storyUrl: storyUrl,
        username: username,
        storyID: storyID,
        uid: uid,
        profilepic: profilePic,
      );
      _firestore.collection('Stories').doc(storyID).set(
            story.tojson(),
          );
      result = 'success';
    } catch (e) {
      result = result.toString();
    }
    return result;
  }

  Future<void> likes(List likes, String uid, String postID) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postID).update(
          {
            'likes': FieldValue.arrayRemove([uid]),
          },
        );
      } else {
        await _firestore.collection('posts').doc(postID).update(
          {
            'likes': FieldValue.arrayUnion([uid]),
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> commentpost(String text, String profilePic, String name,
      String uid, String postID) async {
    try {
      if (text.isNotEmpty) {
        final commentID = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postID)
            .collection('comments')
            .doc(commentID)
            .set(
          {
            'profilePic': profilePic,
            'name': name,
            'uid': uid,
            'text': text,
            'datePublished': DateTime.now(),
            'commentID': commentID,
          },
        );
      } else {
        print('empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletepost(String postID) async {
    try {
      _firestore.collection('posts').doc(postID).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followID) async {
    try {
      var snap = await _firestore.collection('users').doc(uid).get();
      List following = snap.data()!['following'];

      if (following.contains(followID)) {
        await _firestore.collection('users').doc(followID).update(
          {
            'followers': FieldValue.arrayRemove([uid])
          },
        );

        await _firestore.collection('users').doc(uid).update(
          {
            'following': FieldValue.arrayRemove([followID])
          },
        );
      } else {
        await _firestore.collection('users').doc(followID).update(
          {
            'followers': FieldValue.arrayUnion([uid])
          },
        );

        await _firestore.collection('users').doc(uid).update(
          {
            'following': FieldValue.arrayUnion([followID])
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
