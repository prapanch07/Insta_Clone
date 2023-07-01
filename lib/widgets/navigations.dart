import 'package:flutter/material.dart';

import '../screens/screen_login.dart';
import '../screens/screen_signup.dart';
import '../screens/screen_add_story.dart';

void navigateToLogIn(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const ScreenLogin(),
    ),
  );
}

void navigateToSignUp(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const ScreenSignUp(),
    ),
  );
}

void navigateToAddStrory(BuildContext context, usersnap) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => ScreenAddStory(
      usersnap: usersnap,
    ),
  ));
}

// pop navigate

void popNavigate(BuildContext context) {
  Navigator.of(context).pop();
}
