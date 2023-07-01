import 'package:flutter/material.dart';

 customSnackbar(BuildContext context,String content){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}