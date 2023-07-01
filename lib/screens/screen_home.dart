import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/constants/dimensions.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/custom_snackbar.dart';
import 'package:insta_clone/widgets/post_card_widget.dart';

import '../widgets/story_section.dart';

class Screenhome extends StatefulWidget {
  const Screenhome({super.key});

  @override
  State<Screenhome> createState() => _ScreenhomeState();
}

class _ScreenhomeState extends State<Screenhome> {
  ScrollController _scrollController = ScrollController();
  ValueNotifier<bool> scrollNotifier = ValueNotifier(true);

  bool isScrollingDown = false;

  var userdata = {};
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      scrollNotifier.value = false;
    }
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      scrollNotifier.value = true;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userdata = usersnap.data()!;
      setState(() {});
    } catch (e) {
      customSnackbar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: size.width > 600
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              title: SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 32,
              ),
              actions: [
                IconButton(
                  onPressed: () => customSnackbar(context, unavailable),
                  icon: const Icon(Icons.favorite_border),
                ),
                IconButton(
                  onPressed: () => customSnackbar(context, unavailable),
                  icon: const Icon(Icons.messenger_outline),
                )
              ],
            ),
      body: ListView(
        children: [
          ValueListenableBuilder(
            valueListenable: scrollNotifier,
            builder: (context, value, child) {
              return Container(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : scrollNotifier.value == true
                        ? Padding(
                            padding: size.width > 600
                                ? EdgeInsets.symmetric(
                                    horizontal: size.width / 10)
                                : const EdgeInsets.all(0),
                            child: StorySection(userdata: userdata),
                          )
                        : const SizedBox(),
              );
            },
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (
              context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Padding(
                padding: size.width > 600
                    ? EdgeInsets.symmetric(horizontal: size.width / 4)
                    : const EdgeInsets.all(0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .75,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => PostCardWidget(
                      snap: snapshot.data!.docs[index],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );

// scrolling not goood
//correct it
  }
}
