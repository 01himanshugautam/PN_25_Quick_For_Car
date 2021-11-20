import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class SplashLogo extends StatefulWidget {
  const SplashLogo({Key? key}) : super(key: key);

  @override
  _SplashLogo createState() => _SplashLogo();
}

class _SplashLogo extends State<SplashLogo> {
  bool logoTime = false;

  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(milliseconds: 1500), () {
      setState(() {
        logoTime = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logoTime
                ? Text(
                    "Q",
                    style: TextStyle(
                      fontSize: 120,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  )
                : DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 120,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        ScaleAnimatedText(
                          'Q',
                        ),
                      ],
                      isRepeatingAnimation: false,
                    ),
                  ),
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              logoTime
                  ? Text(
                      "uick",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 50,
                      ),
                    )
                  : DefaultTextStyle(
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 50,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          ScaleAnimatedText(
                            'uick',
                          ),
                        ],
                        isRepeatingAnimation: false,
                      ),
                    ),
              logoTime
                  ? Text(
                      "for Car",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                      ),
                    )
                  : DefaultTextStyle(
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          ScaleAnimatedText(
                            'for Car',
                          ),
                        ],
                        isRepeatingAnimation: false,
                      ),
                    ),
            ])
          ],
        ),
      ],
    );
  }
}
