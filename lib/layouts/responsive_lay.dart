import 'package:flutter/material.dart';
import 'package:insta_clone/constants/dimensions.dart';
import 'package:insta_clone/layouts/mobile_screen_layout.dart';
import 'package:insta_clone/layouts/web_screen_layout.dart';
import 'package:insta_clone/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({super.key});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userprovider = Provider.of(
      context,
      listen: false,
    );
    await _userprovider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        if (constraints.maxWidth <= webLayoutsize) {
          return  MobileScreenLayout();
        } else {
          return const WebScreenLayout();
        }
      },
    );
  }
}
