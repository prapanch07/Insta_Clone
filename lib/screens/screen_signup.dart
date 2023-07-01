import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/auths/auth.dart';
import 'package:insta_clone/layouts/responsive_lay.dart';

import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/imagepicker.dart';
import 'package:insta_clone/widgets/custom_snackbar.dart';
import 'package:insta_clone/widgets/custom_text_field.dart';
import 'package:insta_clone/widgets/navigations.dart';

class ScreenSignUp extends StatefulWidget {
  const ScreenSignUp({super.key});

  @override
  State<ScreenSignUp> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenSignUp> {
  final emailsignupcontroller = TextEditingController();
  final passsignupcontroller = TextEditingController();
  final usernamecontroller = TextEditingController();
  final biocontroller = TextEditingController();
  Uint8List? _image;
  bool _isloading = false;
  bool _showpass = false;

  @override
  void dispose() {
    super.dispose();
    emailsignupcontroller.dispose();
    passsignupcontroller.dispose();
    usernamecontroller.dispose();
    biocontroller.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery, context);

    setState(() {
      _image = img;
    });
  }

  void signUpUser() async {
    setState(() {
      _isloading = true;
    });
    final res = await AuthMethods().signUp(
      username: usernamecontroller.text,
      email: emailsignupcontroller.text,
      password: passsignupcontroller.text,
      bio: biocontroller.text,
      file: _image!,
    );

    setState(() {
      _isloading = false;
    });
    if (res != 'success') {
      customSnackbar(context, 'Account Created ');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(),
      ));
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(),
        ),
      );
    }
  }

  void showPass() {
    setState(() {
      _showpass = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: size.width > 600
              ? EdgeInsets.symmetric(horizontal: size.width / 4, vertical: 30)
              : const EdgeInsets.all(30.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(),
                ),

                // svg logo

                SvgPicture.asset(
                  "assets/ic_instagram.svg",
                  height: 64,
                  // ignore: deprecated_member_use
                  color: primaryColor,
                ),

                const SizedBox(
                  height: 25,
                ),

                // profile pic from gallary

                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            backgroundColor: Colors.blue,
                            backgroundImage: NetworkImage(
                                'https://t4.ftcdn.net/jpg/03/46/93/61/360_F_346936114_RaxE6OQogebgAWTalE1myseY1Hbb5qPM.jpg'),
                            radius: 64,
                          ),
                    Positioned(
                      bottom: -8,
                      right: -8,
                      child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo)),
                    )
                  ],
                ),

                const SizedBox(
                  height: 12,
                ),

                // username

                CustomTextFeild(
                  hintText: 'username',
                  keyboardtype: TextInputType.text,
                  obscureText: false,
                  controller: usernamecontroller,
                ),

                const SizedBox(
                  height: 24,
                ),

                // email text feild

                CustomTextFeild(
                  hintText: 'email',
                  keyboardtype: TextInputType.emailAddress,
                  obscureText: false,
                  controller: emailsignupcontroller,
                ),

                const SizedBox(
                  height: 24,
                ),

                // pass text feild
                Stack(
                  children: [
                    CustomTextFeild(
                      hintText: 'Password',
                      keyboardtype: TextInputType.visiblePassword,
                      obscureText: _showpass == true ? false : true,
                      controller: passsignupcontroller,
                    ),
                    Positioned(
                      right: 10,
                      top: 15,
                      child: InkWell(
                        onTap: () {
                          showPass();
                          Future.delayed(const Duration(milliseconds: 500), () {
                            setState(() {
                              _showpass = false;
                            });
                          });
                        },
                        child: _showpass
                            ? const Icon(
                                Icons.visibility_off,
                                size: 20,
                              )
                            : const Icon(
                                Icons.visibility,
                                size: 20,
                              ),
                      ),
                    )
                  ],
                ),

                const SizedBox(
                  height: 24,
                ),

                // bio

                CustomTextFeild(
                  hintText: 'bio',
                  keyboardtype: TextInputType.text,
                  obscureText: false,
                  controller: biocontroller,
                ),

                const SizedBox(
                  height: 24,
                ),

                //  sigin button

                InkWell(
                  onTap: () => signUpUser(),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: ShapeDecoration(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: _isloading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text('Signup'),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    GestureDetector(
                      onTap: () => navigateToLogIn(context),
                      child: const Text(
                        ' Login here',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
