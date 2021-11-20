import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:service_app/functions/functions.dart';
import 'package:service_app/helper/helper.dart';
import 'package:service_app/screens/home.dart';
import 'package:service_app/screens/login.dart';
import 'package:service_app/screens/onboard.dart';
import 'package:service_app/screens/register.dart';
import 'package:service_app/screens/splash.dart';
import 'package:service_app/screens/update_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  registerNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage(SPLASH_IMAGE), context);
    return MaterialApp(
      title: 'Quick for Car',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (context) => Splash(),
        "/login": (context) => Login(),
        "/onboard": (context) => OnBoard(),
        "/register": (context) => Register(),
        "/home": (context) => Home(),
        "/update_profile": (context) => UpdateProfile(),
      },
    );
  }
}
