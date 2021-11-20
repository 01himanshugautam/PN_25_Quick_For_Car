import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_app/screens/home_screen.dart';
import 'package:service_app/screens/petrol_screen.dart';
import 'package:service_app/screens/profile.dart';
import 'package:service_app/screens/towing_screen.dart';
import 'package:service_app/screens/washing_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        pageSnapping: true,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        physics: BouncingScrollPhysics(),
        restorationId: _selectedIndex.toString(),
        // padEnds: true,
        children: <Widget>[
          HomeScreen(),
          TowingScreen(),
          PetrolScreen(),
          WashingScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) {
          setState(() => _selectedIndex = index);
          _pageController.jumpToPage(index);
        },
        itemCornerRadius: 10,
        items: [
          BottomNavyBarItem(
            textAlign: TextAlign.center,
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: CupertinoColors.activeBlue,
            inactiveColor: CupertinoColors.systemGrey,
          ),
          BottomNavyBarItem(
            textAlign: TextAlign.center,
            icon: Icon(Icons.car_repair),
            title: Text("Towing"),
            activeColor: CupertinoColors.activeOrange,
            inactiveColor: CupertinoColors.systemGrey,
          ),
          BottomNavyBarItem(
            textAlign: TextAlign.center,
            icon: Icon(Icons.home_repair_service),
            title: Text("Alignment"),
            activeColor: CupertinoColors.activeGreen,
            inactiveColor: CupertinoColors.systemGrey,
          ),
          BottomNavyBarItem(
            textAlign: TextAlign.center,
            icon: Icon(Icons.bathtub_sharp),
            title: Text("Car Washing"),
            activeColor: Colors.indigo,
            inactiveColor: CupertinoColors.systemGrey,
          ),
          BottomNavyBarItem(
            textAlign: TextAlign.center,
            icon: Icon(Icons.person),
            title: Text("Profile"),
            activeColor: CupertinoColors.systemPurple,
            inactiveColor: CupertinoColors.systemGrey,
          ),
        ],
      ),
    );
  }
}
