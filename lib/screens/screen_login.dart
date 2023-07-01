import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/auths/auth.dart';

import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/custom_snackbar.dart';
import 'package:insta_clone/widgets/custom_text_field.dart';
import 'package:insta_clone/widgets/navigations.dart';

import '../layouts/responsive_lay.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final emaillogincontroller = TextEditingController();
  final passlogincontroller = TextEditingController();
  bool isloading = false;
  bool _showpass = false;

  @override
  void dispose() {
    super.dispose();
    emaillogincontroller.dispose();
    passlogincontroller.dispose();
  }

  void loginUser() async {
    setState(() {
      isloading = true;
    });

    String res = await AuthMethods().login(
      email: emaillogincontroller.text,
      password: passlogincontroller.text,
    );
    if (res == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(),
        ),
      );
    } else {
      customSnackbar(context, res);
    }

    setState(() {
      isloading = false;
    });
  }

  void showPass() {
    setState(() {
      _showpass = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: MediaQuery.of(context).size.width < 600
              ? const EdgeInsets.all(30.0)
              : EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 4,
                  vertical: 100),
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
                  color: primaryColor,
                ),

                const SizedBox(
                  height: 64,
                ),

                // email text feild

                CustomTextFeild(
                  hintText: 'email',
                  keyboardtype: TextInputType.emailAddress,
                  obscureText: false,
                  controller: emaillogincontroller,
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
                      controller: passlogincontroller,
                    ),
                    Positioned(
                      right: 10,
                      top: 13,
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

                //  sigin button

                InkWell(
                  onTap: () => loginUser(),
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
                    child: isloading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text('Login'),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't you have an account?"),
                    GestureDetector(
                      onTap: () => navigateToSignUp(context),
                      child: const Text(
                        ' SignUp',
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
