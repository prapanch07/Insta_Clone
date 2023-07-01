import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/auths/storage.dart';
import 'package:insta_clone/model/user_model.dart';
import 'package:insta_clone/model/user_model.dart ' as model;

class AuthMethods {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<Users> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snapsht =
        await _firestore.collection("users").doc(currentUser.uid).get();

    return Users.fromSnaptoUserm(snapsht);
  }

  // signup

  signUp(
      {required String username,
      required String email,
      required String password,
      required String bio,
      required Uint8List file,  
      BuildContext? context}) async {
    String res = 'some error occured';

    try {
      if (username.isNotEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          bio.isEmpty) {
        // firebase auth signup

        final UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // get url to store in db

        final String photoUrl = await StorageMethods()
            .uploadImageToString('profile-pic', file, false);

// save in firestore

        model.Users user = model.Users(
          username: username,
          email: email,
          password: password,
          uid: cred.user!.uid,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.tojson(),
            );

       
        res = "succes";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
    
  }

// login

  login({
    required String email,
    required String password,
  }) async {
    String res = "some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
      } else {
        res = "enter all fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

    signout()async{
    await FirebaseAuth.instance.signOut();
  }
}
