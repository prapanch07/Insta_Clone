import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/firebase_options.dart';
import 'package:insta_clone/layouts/responsive_lay.dart';
import 'package:insta_clone/provider/user_provider.dart';
import 'package:insta_clone/screens/screen_login.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import 'widgets/custom_snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, snap) {
            if (snap.connectionState == ConnectionState.active) {
              if (snap.hasData) {
                return const ResponsiveLayout();
              } else if (snap.hasError) {
                return customSnackbar(
                  context,
                  '${snap.error}',
                );
              }
            } else if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            return const ScreenLogin();
          },
        ),
      ),
    );
  }
}
