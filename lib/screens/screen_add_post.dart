import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/auths/firestore_auth.dart';

import 'package:insta_clone/model/user_model.dart';
import 'package:insta_clone/provider/user_provider.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/imagepicker.dart';
import 'package:insta_clone/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';

class ScreenAddPost extends StatefulWidget {
  const ScreenAddPost({super.key});

  @override
  State<ScreenAddPost> createState() => _ScreenAddPostState();
}

class _ScreenAddPostState extends State<ScreenAddPost> {
  final captioncontroller = TextEditingController();
  Uint8List? _file;
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    @override
    void dispose() {
      super.dispose();
      captioncontroller;
    }

    void clearImage() {
      setState(() {
        _file = null;
      });
    }

    void postImage(
        {required String uid,
        required String username,
        required String profileImage}) async {
      setState(() {
        isloading = true;
      });
      try {
        // print(UserProvider().getuser.username.toString());
        String res = await firestoreMethods().uploadpost(
          captioncontroller.text,
          uid,
          _file!,
          username,
          profileImage,
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

    selectImage(BuildContext context) async {
      return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera, context);
                  setState(
                    () {
                      _file = file;
                    },
                  );
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Pick from gallary'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file =
                      await pickImage(ImageSource.gallery, context);
                  setState(
                    () {
                      _file = file;
                    },
                  );
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('cancel'), 

                
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    final Users user = Provider.of<UserProvider>(context).getuser;
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () => clearImage(),
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text('Post to'),
              actions: [
                TextButton(
                  onPressed: () => postImage(
                    uid: user.uid,
                    username: user.username,
                    profileImage: user.photoUrl,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                        color: blueColor,
                        fontSize: 16, 
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                isloading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    SizedBox(
                      width: size.width * .45,
                      child: TextField(
                        controller: captioncontroller,
                        decoration: const InputDecoration(
                          hintText: 'Write a Caption...',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: MemoryImage(_file!),
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                          )),
                        ),
                      ),
                    ),
                    const Divider()
                  ],
                )
              ],
            ),
          );
  }
}
