import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:service_app/functions/functions.dart';
import 'package:service_app/helper/helper.dart';
import 'package:service_app/screens/components/logo.dart';
import 'package:service_app/screens/home.dart';
import 'package:service_app/screens/login.dart';
import 'package:service_app/screens/onboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkingUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                SplashLogo(),
                Image.asset(
                  SPLASH_IMAGE,
                  fit: BoxFit.contain,
                )
              ]),
        ),
      ),
    );
  }
}
