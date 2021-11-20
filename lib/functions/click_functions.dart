import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:service_app/helper/controller.dart';
import 'package:service_app/helper/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'functions.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String verification = "";
String phoneNumber = "";

logout(context) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("user", false);
  prefs.setString("uid", "");
  Navigator.pushReplacementNamed(context, "/login");
}

getLocation() async {
  final prefs = await SharedPreferences.getInstance();
  var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  final coordinates = new Coordinates(position.latitude, position.longitude);
  var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  prefs.setDouble("longitude", position.longitude);
  prefs.setDouble("latitude", position.latitude);
  prefs.setString("address", address.first.addressLine);
}

phoneInputModal(context) async {
  registerPhoneController.text = "";
  final prefs = await SharedPreferences.getInstance();
  Alert(
      context: context,
      title: "Verify Phone Number",
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: IntlPhoneField(
          controller: registerPhoneController,
          showDropdownIcon: false,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: "Phone Number",
          ),
          initialCountryCode: 'IN',
          onChanged: (phone) {
            print(phone.completeNumber);
            phoneNumber = phone.completeNumber;
          },
        ),
      ),
      closeIcon: Icon(
        Icons.logout,
        color: Colors.transparent,
      ),
      closeFunction: () {
        Navigator.pushNamed(context, "/home");
      },
      buttons: [
        DialogButton(
          onPressed: () async {
            if (prefs.getBool("forgotPass") != true) {
              Dio dio = new Dio();
              var formData =
                  FormData.fromMap({'phone': phoneNumber, 'check_phone': ""});
              var response = await dio.post(
                  API_URL + USER_API + "?" + API_KEY_TEXT + "=" + API_KEY,
                  data: formData);
              print(response.data['message']);
              if (response.data['error'] == false) {
                phoneAuth(context);
              } else {
                Navigator.pop(context);
                AlertDialog alertDialogNew = AlertDialog(
                  content: Container(
                    height: 100,
                    child: Column(
                      children: [
                        Text(response.data['message']),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Ok"))
                      ],
                    ),
                  ),
                );
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alertDialogNew;
                  },
                );
              }
            } else {
              phoneAuth(context);
            }
          },
          child: Text(
            "Get OTP",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
}

otpinputModal(context) async {
  final prefs = await SharedPreferences.getInstance();
  Alert(
      context: context,
      title: "Verify Otp",
      content: Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        child: PinPut(
          controller: otpInputController,
          fieldsAlignment: MainAxisAlignment.center,
          eachFieldAlignment: Alignment.bottomCenter,
          fieldsCount: 6,
          pinAnimationType: PinAnimationType.scale,
          onSubmit: (String pin) => print(pin),
          inputDecoration: InputDecoration(
              labelText: "Enter OTP",
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 5.0),
              )),
        ),
      ),
      closeIcon: Icon(
        Icons.logout,
        color: Colors.transparent,
      ),
      closeFunction: () {
        // Navigator.pushNamed(context, "/home");
      },
      buttons: [
        DialogButton(
          onPressed: () => authOTP(context),
          child: prefs.getBool("forgotPass") == true
              ? Text(
                  "Next",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              : Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
        )
      ]).show();
}

showLoading(context) {
  AlertDialog alert = AlertDialog(
      content: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
          height: 200,
          width: 200,
          alignment: Alignment.center,
          child: Lottie.asset(LOADING)),
    ],
  ));

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

phoneAuth(context) async {
  Navigator.pop(context);
  showLoading(context);
  auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) {
      // auth.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      print(e.message);
    },
    codeSent: (verificationId, resendToken) async {
      verification = verificationId;
      print(verification);
      Navigator.pop(context);
      otpinputModal(context);
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      SnackBar snackBar = new SnackBar(
        content: Text("Session Timeout"),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    },
  );
}

forgotPassword(context) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("forgotPass", true);
  phoneInputModal(context);
}

authOTP(context) async {
  final prefs = await SharedPreferences.getInstance();
  print(verification);
  try {
    final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verification, smsCode: otpInputController.text);
    await auth.signInWithCredential(credential).then((user) => {
          if (prefs.getBool("forgotPass") == true)
            {
              otpInputController.text = "",
              Navigator.pop(context),
              forgotPasswordModal(context),
            }
          else
            {
              otpInputController.text = "",
              updatePhoneController.text = phoneNumber,
              Navigator.pushReplacementNamed(context, "/update_profile"),
            }
        });
  } catch (e) {
    print(e);
  }
}

forgotPasswordModal(context) {
  Alert(
      context: context,
      title: "Forgot Password",
      content: Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        child: TextField(
          controller: forgotPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Enter New Password",
            prefixIcon: Icon(Icons.lock),
          ),
        ),
      ),
      closeIcon: Icon(
        Icons.logout,
        color: Colors.transparent,
      ),
      closeFunction: () {
        // Navigator.pushNamed(context, "/home");
      },
      buttons: [
        DialogButton(
          onPressed: () => changePassword(
              phoneNumber, forgotPasswordController.text, context),
          child: Text(
            "Change Password",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
}

File? _image;
updateNameModal(
    context, String name, String uid, String email, String profileImage) {
  updateUserNameController.text = name;
  updateEmailController.text = email;
  Alert(
      context: context,
      title: "Update Profile",
      content: Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                final picker = ImagePicker();
                final pickedFile =
                    await picker.getImage(source: ImageSource.gallery);
                _image = File(pickedFile!.path);
                Navigator.pop(context);
                updateNameModal(context, name, uid, email, profileImage);
              },
              child: Container(
                  height: 80,
                  width: 80,
                  child: _image == null
                      ? profileImage == "placeholder.jpg"
                          ? Stack(
                              children: [
                                CircleAvatar(
                                  radius: 35,
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
                              ],
                            )
                          : Stack(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(IMAGE_PATH +
                                      "profileImages/" +
                                      profileImage),
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
                              ],
                            )
                      : Stack(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: FileImage(_image!),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Icon(
                                    Icons.camera_enhance,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                )),
                          ],
                        )),
            ),
            TextField(
              controller: updateUserNameController,
              decoration: InputDecoration(
                labelText: "Enter Name",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextField(
              controller: updateEmailController,
              decoration: InputDecoration(
                labelText: "Enter Email",
                prefixIcon: Icon(Icons.mail),
              ),
            ),
          ],
        ),
      ),
      closeIcon: Icon(
        Icons.close,
        // color: Colors.transparent,
      ),
      closeFunction: () {
        Navigator.pop(context);
        _image = null;
      },
      buttons: [
        DialogButton(
          onPressed: () => changeName(context, uid, _image!),
          child: Text(
            "Update",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
}

userLocation() async {
  var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  final coordinates = Coordinates(position.latitude, position.longitude);
  var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  if (address != null) {
    return address.first.addressLine;
  } else {
    return null;
  }
}

getCurrentPosition() async {
  var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return LatLng(position.latitude, position.longitude);
}
