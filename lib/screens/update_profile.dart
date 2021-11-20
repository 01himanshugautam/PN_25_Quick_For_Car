import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app/functions/click_functions.dart';
import 'package:service_app/functions/functions.dart';
import 'package:service_app/helper/controller.dart';
import 'package:service_app/helper/helper.dart';

class UpdateProfile extends StatefulWidget {
  @override
  UpdateProfileState createState() => UpdateProfileState();
}

class UpdateProfileState extends State<UpdateProfile> {
  final picker = ImagePicker();
  File? _image = null;
  var token;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging _messaging = FirebaseMessaging.instance;
    _messaging.getToken().then((value) {
      token = value.toString();
    });

    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Hero(
                    tag: "background",
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              spreadRadius: 3,
                              blurRadius: 3,
                              offset:
                                  Offset(0, 1), // changes position of shadow
                            ),
                          ],
                          image: DecorationImage(
                              image: AssetImage(
                                USER_BG,
                              ),
                              colorFilter: ColorFilter.mode(
                                  Colors.black12.withOpacity(0.1),
                                  BlendMode.darken),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Update Profile",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 20,
                              color: Colors.grey,
                            )
                          ],
                          color: Colors.blue),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 30,
                    left: 10,
                    right: 10,
                  ),
                  margin: EdgeInsets.symmetric(vertical: 30),
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: Offset(1, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () {
                            getImage();
                          },
                          child: Center(
                              child: _image == null
                                  ? Stack(children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            AssetImage(USER_PLACEHOLDER_IMAGE),
                                      ),
                                      Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            child: Icon(
                                              Icons.camera_enhance,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          )),
                                    ])
                                  : Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundImage: FileImage(_image!),
                                        ),
                                        Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40)),
                                              child: Icon(
                                                Icons.camera_enhance,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            )),
                                      ],
                                    ))),
                      TextField(
                        controller: updateUserNameController,
                        decoration: InputDecoration(
                          labelText: "Enter Full Name",
                          prefixIcon: Icon(Icons.people),
                        ),
                      ),
                      TextField(
                        controller: updatePhoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Phone",
                          enabled: false,
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                      TextField(
                        controller: updateEmailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.mail),
                        ),
                      ),
                      TextField(
                        controller: updatePasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (_image == null) {
                              updateProfile(null, context, token);
                            } else {
                              updateProfile(_image!, context, token);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.6,
                            alignment: Alignment.center,
                            child: Text(
                              "Update",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
