import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lottie/lottie.dart';
import 'package:service_app/helper/helper.dart';
import 'package:service_app/screens/login.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  int position = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      Hero(
        tag: "logo",
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.lightBlue,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                CAR_REPAIR_IMAGE,
                height: 300,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                QUICK_FOR_CAR,
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20),
              Container(
                width: 250,
                alignment: Alignment.center,
                child: Text(
                  QUICK_FOR_CAR_DESC,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )
            ],
          )),
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.orange,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                FUEL_IMAGE,
                height: 300,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                FUEL_FOR_CAR,
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20),
              Container(
                width: 250,
                alignment: Alignment.center,
                child: Text(
                  FUEL_FOR_CAR_DESC,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.indigo,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                      image: DecorationImage(image: AssetImage(TOWING_IMAGE))),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  TOWING_FOR_CAR,
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 20),
                Container(
                  width: 250,
                  alignment: Alignment.center,
                  child: Text(
                    TOWING_FOR_CAR_DESC,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            )),
            Positioned(
              bottom: 30,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => Login()));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Getting Start",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ];

    return Scaffold(
      body: Builder(
          builder: (context) => LiquidSwipe(
                enableLoop: false,
                pages: pages,
                enableSideReveal: true,
                waveType: WaveType.liquidReveal,
                onPageChangeCallback: (s) {
                  setState(() {
                    position = s;
                  });
                },
                slideIconWidget: position == 2
                    ? Text("")
                    : Container(
                        padding: EdgeInsets.only(right: 20, top: 25),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
              )),
    );
  }
}
