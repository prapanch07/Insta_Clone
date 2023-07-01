import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/auths/firestore_auth.dart';
import 'package:insta_clone/constants/dimensions.dart';
import 'package:insta_clone/provider/user_provider.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/imagepicker.dart';
import 'package:insta_clone/widgets/custom_snackbar.dart';
import 'package:insta_clone/widgets/customized_icon_bb.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';

class ScreenAddStory extends StatefulWidget {
  final usersnap;
  const ScreenAddStory({super.key, required this.usersnap});

  @override
  State<ScreenAddStory> createState() => _ScreenAddStoryState();
}

class _ScreenAddStoryState extends State<ScreenAddStory> {
  Uint8List? _file;
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    void clearImage() {
      setState(() {
        _file = null;
      });
    }

    void postStory(
        {required String username,
        required String uid,
        required String profilePic}) async {
      try {
        String res = await firestoreMethods().uploadstory(
          username,
          uid,
          profilePic,
          _file!,
        );

        if (res == 'success') {
          setState(() {
            isloading = false;
          });
          customSnackbar(context, 'posted');
          clearImage();
        } else {
          isloading = false;
          customSnackbar(context, res);
        }

      } catch (e) {
        customSnackbar(context, e.toString());
      }
    }

    final Users user = Provider.of<UserProvider>(context).getuser;
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: _file == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Select Your Story From :'),
                  TextButton.icon(
                    onPressed: () async {
                      Uint8List file =
                          await pickImage(ImageSource.gallery, context);
                      setState(
                        () {
                          _file = file;
                        },
                      );
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallary'),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      Uint8List file =
                          await pickImage(ImageSource.camera, context);
                      setState(() {
                        _file = file;
                      });
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Camera'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height * .7,
                            image: MemoryImage(_file!),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () => clearImage(),
                              icon: const Icon(Icons.arrow_back_ios),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * .2),
                            CustomIconButton(
                              func: () => customSnackbar(context, unavailable),
                              icon: Icons.crop,
                              size: 23,
                            ),
                            CustomIconButton(
                              func: () => customSnackbar(context, unavailable),
                              icon: Icons.translate_sharp,
                              size: 23,
                            ),
                            CustomIconButton(
                              func: () => customSnackbar(context, unavailable),
                              icon: Icons.sticky_note_2_outlined,
                              size: 23,
                            ),
                            CustomIconButton(
                              func: () => customSnackbar(context, unavailable),
                              icon: Icons.star_border_sharp,
                              size: 23,
                            ),
                            CustomIconButton(
                              func: () => customSnackbar(context, unavailable),
                              icon: Icons.more_horiz,
                              size: 23,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * .35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(66, 43, 41, 41),
                        ),
                        child: isloading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      widget.usersnap['photoUrl'],
                                    ),
                                    radius: 12,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () => postStory(
                                      uid: user.uid,
                                      username: user.username,
                                      profilePic: user.photoUrl,
                                    ),
                                    child: const Text(
                                      'Your story',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                      ),
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * .35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(66, 43, 41, 41),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 12,
                              child: Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Close friends',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => customSnackbar(context, unavailable),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 22,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
// story section  ... display in home in story mode ... 
 