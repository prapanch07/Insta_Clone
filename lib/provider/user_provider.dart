
import 'package:flutter/material.dart';
import 'package:insta_clone/auths/auth.dart';
import 'package:insta_clone/model/user_model.dart';

class UserProvider with ChangeNotifier {
  Users? _user;

final _authmethods = AuthMethods();

  Users get getuser => _user!;

  Future<void>refreshUser() async{

   Users user = await _authmethods.getUserDetails();

   _user = user;
   notifyListeners();
  }
}

