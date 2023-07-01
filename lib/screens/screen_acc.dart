import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/auths/auth.dart';
import 'package:insta_clone/auths/firestore_auth.dart';
import 'package:insta_clone/constants/dimensions.dart';
import 'package:insta_clone/screens/screen_login.dart';
import 'package:insta_clone/screens/screen_message.dart';

import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/F_F_status_widget.dart';
import 'package:insta_clone/widgets/acc_button.dart';
import 'package:insta_clone/widgets/acc_profile_tab_bar.dart';
import 'package:insta_clone/widgets/custom_snackbar.dart';
import 'package:insta_clone/widgets/display_bio_line_by_line.dart';

import '../widgets/acc_highlight_section.dart';
import '../widgets/discover_people.dart';

class ScreenAccount extends StatefulWidget {
  final String uid;
  const ScreenAccount({super.key, required this.uid});

  @override
  State<ScreenAccount> createState() => _ScreenAccountState();
}

class _ScreenAccountState extends State<ScreenAccount>
    with SingleTickerProviderStateMixin {
  var userData = {};

  int postlenth = 0;
  int followers = 0;
  int following = 0;
  int currentfollowig = 0;
  bool discoverPeople = false;

  bool isfollowing = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });

      var usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postsnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      var postlen = postsnap.docs.length;

      userData = usersnap.data()!;
      followers = userData['followers'].length;
      following = userData['following'].length;
      postlenth = postlen;

      isfollowing = userData['followers'].contains(
        FirebaseAuth.instance.currentUser!.uid,
      );
      setState(() {});
    } catch (e) {
      customSnackbar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  String BioDisplayLineByLine(String text, int wordLimit) {
    List<String> words = text.split(' ');
    List<String> lines = [];

    String currentLine = '';

    for (int i = 0; i < words.length; i++) {
      String word = words[i];

      if ((currentLine + word).length <= wordLimit) {
        currentLine += word + ' ';
      } else {
        lines.add(currentLine.trim());
        currentLine = word + ' ';
      }

      if (i == words.length - 1) {
        lines.add(currentLine.trim());
      }
    }

    return lines.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              actions: [
                IconButton(
                  onPressed: () => customSnackbar(context, unavailable),
                  icon: const Icon(Icons.add_box_outlined),
                ),
                IconButton(
                  onPressed: () {
                    AuthMethods().signout();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const ScreenLogin(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                )
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: size.width > 600
                      ? const EdgeInsets.symmetric(horizontal: 150)
                      : const EdgeInsets.all(16.0),
                  child: Column( 
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(userData['photoUrl']),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FFStatusWidget(
                                      label: 'Posts',
                                      FFStatus: postlenth.toString(),
                                    ),
                                    FFStatusWidget(
                                      label: 'followers',
                                      FFStatus: followers.toString(),
                                    ),
                                    FFStatusWidget(
                                      label: 'following',
                                      FFStatus: following.toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(userData['username']),
                      ),
                      DisplayBio(userdata: userData),
                      const SizedBox(
                        height: 5,
                      ),
                      FirebaseAuth.instance.currentUser!.uid == widget.uid
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                AccountButton(
                                  function: () {},
                                  label: 'Edit profile',
                                  backgroundColor:
                                      const Color.fromARGB(40, 158, 158, 158),
                                ),
                                AccountButton(
                                  function: () =>
                                      customSnackbar(context, unavailable),
                                  label: 'Share profile',
                                  backgroundColor:
                                      const Color.fromARGB(40, 158, 158, 158),
                                ),
                                Container(
                                  height: 29,
                                  width: 29,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          40, 158, 158, 158),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          discoverPeople = !discoverPeople;
                                        });
                                      },
                                      child: discoverPeople
                                          ? const Icon(
                                              Icons.person_add,
                                              size: 20,
                                            )
                                          : const Icon(
                                              Icons.person_add_outlined,
                                              size: 20,
                                            )),
                                ),
                              ],
                            )
                          : isfollowing
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    AccountButton(
                                      function: () async {
                                        await firestoreMethods().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userData['uid'],
                                        );
                                        setState(() {
                                          isfollowing = false;
                                          followers--;
                                        });
                                      },
                                      label: 'unfollow',
                                      backgroundColor: const Color.fromARGB(
                                          40, 158, 158, 158),
                                    ),
                                    AccountButton(
                                      function: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MessageScreen(uid: widget.uid),
                                          ),
                                        );
                                      },
                                      label: 'Message',
                                      backgroundColor: const Color.fromARGB(
                                          40, 158, 158, 158),
                                    ),
                                    // if time add function to make discover peapole
                                    Container(
                                      height: 29,
                                      width: 29,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              40, 158, 158, 158),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              discoverPeople = !discoverPeople;
                                            });
                                          },
                                          child: discoverPeople
                                              ? const Icon(
                                                  Icons.person_add,
                                                  size: 20,
                                                )
                                              : const Icon(
                                                  Icons.person_add_outlined,
                                                  size: 20,
                                                )),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    AccountButton(
                                      function: () async {
                                        await firestoreMethods().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userData['uid'],
                                        );
                                        setState(() {
                                          isfollowing = true;
                                          followers++;
                                        });
                                      },
                                      label: 'follow',
                                      backgroundColor: Colors.blue,
                                    ),
                                    AccountButton(
                                      function: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MessageScreen(uid: widget.uid),
                                          ),
                                        );
                                      },
                                      label: 'Message',
                                      backgroundColor: const Color.fromARGB(
                                          40, 158, 158, 158),
                                    ),
                                    // if time add function to make discover peapole
                                    Container(
                                      height: 29,
                                      width: 29,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              40, 158, 158, 158),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              discoverPeople = !discoverPeople;
                                            });
                                          },
                                          child: discoverPeople
                                              ? const Icon(
                                                  Icons.person_add,
                                                  size: 20,
                                                )
                                              : const Icon(
                                                  Icons.person_add_outlined,
                                                  size: 20,
                                                )),
                                    ),
                                  ],
                                ),
                      Column(
                        children: [
                          discoverPeople
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                          left: 0,
                                          right: 0,
                                        ),
                                        child: Text(
                                          'Suggested For You',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('users')
                                            .snapshots(),
                                        builder: (context,
                                            AsyncSnapshot<
                                                    QuerySnapshot<
                                                        Map<String, dynamic>>>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          return LimitedBox(
                                            maxHeight: 150,
                                            child: ListView.builder(
                                              itemCount:
                                                  snapshot.data!.docs.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return DiscoverPeopleWidget(
                                                  snap: snapshot
                                                      .data!.docs[index],
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ), 
                                )
                              : const HighlightSection(), 
                          SizedBox(
                            width: double.infinity,
                            height: 1000,
                            child: AccountTabbarView(
                              uid: widget.uid,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
