import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:service_app/functions/click_functions.dart';
import 'package:service_app/helper/controller.dart';
import 'package:service_app/helper/helper.dart';
import 'package:service_app/models/CategoryModal.dart';
import 'package:service_app/models/PushNotification.dart';
import 'package:service_app/screens/home.dart';
import 'package:service_app/screens/login.dart';
import 'package:service_app/screens/onboard.dart';
import 'package:service_app/screens/profile.dart';
import 'package:service_app/services/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

loadPrefrences() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs;
}

checkingUser(context) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool("user") == true) {
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              transitionDuration: Duration(seconds: 1),
              pageBuilder: (_, __, ___) => Home()));
    });
  } else {
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              transitionDuration: Duration(seconds: 1),
              pageBuilder: (_, __, ___) => OnBoard()));
    });
  }
}

checkLoggedin(context) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool("user") == true) {
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              transitionDuration: Duration(seconds: 1),
              pageBuilder: (_, __, ___) => Home()));
    });
  } else {
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              transitionDuration: Duration(seconds: 1),
              pageBuilder: (_, __, ___) => Login()));
    });
  }
}

updateProfile(image, context, String token) async {
  if (updateUserNameController.text != "" &&
      updateEmailController.text != "" &&
      updatePasswordController.text != "") {
    final prefs = await SharedPreferences.getInstance();
    showLoading(context);

    Dio dio = new Dio();
    Random random = new Random();
    var formData = FormData.fromMap({
      'name': updateUserNameController.text,
      'email': updateEmailController.text,
      'phone': phoneNumber,
      'password': updatePasswordController.text,
      'register': '',
      'longitude': prefs.getDouble("longitude"),
      'latitude': prefs.getDouble("latitude"),
      'address': prefs.getString("address"),
      'token': token,
      'profileImage': image == null
          ? await MultipartFile.fromString(USER_PLACEHOLDER_IMAGE,
              filename: "placeholder.jpg")
          : await MultipartFile.fromFile(image.path,
              filename: "user_profile_" +
                  random.nextInt(99999999).toString() +
                  ".jpg"),
    });
    var response = await dio.post(
        API_URL + USER_API + "?" + API_KEY_TEXT + "=" + API_KEY,
        data: formData);
    print(response.data['data']['message'].toString());
    if (response.data['data']['error'] == false) {
      prefs.setString("uid", response.data['data']['uid']);
      prefs.setBool("user", true);
      Navigator.pop(context);
      AlertDialog alertDialogNew2 = AlertDialog(
        content: Container(
          height: 80,
          child: Column(
            children: [
              Text(response.data['data']['message']),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    updateUserNameController.text = "";
                    updateEmailController.text = "";
                    phoneNumber = "";
                    updatePasswordController.text = "";
                    Navigator.pushReplacementNamed(context, "/home");
                  },
                  child: Text("Ok"))
            ],
          ),
        ),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialogNew2;
        },
      );
    } else {
      prefs.setBool("user", false);
      Navigator.pop(context);
      AlertDialog alertDialogNew = AlertDialog(
        content: Container(
          height: 100,
          child: Column(
            children: [
              Text(response.data['data']['message']),
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
    AlertDialog alertDialogNew = AlertDialog(
      content: Container(
        height: 80,
        child: Column(
          children: [
            Text("All Fields Are Required"),
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
}

createAccount(context) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("forgotPass", false);
  phoneInputModal(context);
}

loginUser(context, String phone, String password, String token) async {
  if (phone != "" && password != "") {
    final prefs = await SharedPreferences.getInstance();
    showLoading(context);

    Dio dio = new Dio();
    var formData = FormData.fromMap(
        {'auth': phone, 'password': password, 'token': token, 'login': ""});
    var response = await dio.post(
        API_URL + USER_API + "?" + API_KEY_TEXT + "=" + API_KEY,
        data: formData);
    print(response.data['message'].toString());
    if (response.data['error'] == false) {
      prefs.setString("uid", response.data['uid']);
      prefs.setBool("user", true);
      Navigator.pop(context);
      AlertDialog alertDialogNew2 = AlertDialog(
        content: Container(
          height: 80,
          child: Column(
            children: [
              Text(response.data['message']),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    loginEmailController.text = "";
                    loginPasswordController.text = "";
                    Navigator.pushReplacementNamed(context, "/home");
                  },
                  child: Text("Ok"))
            ],
          ),
        ),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialogNew2;
        },
      );
    } else {
      prefs.setBool("user", false);
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
    AlertDialog alertDialogNew = AlertDialog(
      content: Container(
        height: 80,
        child: Column(
          children: [
            Text("All Fields Are Required"),
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
}

changePassword(String phone, String password, context) async {
  if (phone != "" && password != "") {
    final prefs = await SharedPreferences.getInstance();
    showLoading(context);

    Dio dio = new Dio();
    Random random = new Random();
    var formData = FormData.fromMap(
        {'phone': phone, 'password': password, 'password_reset': ""});
    var response = await dio.post(
        API_URL + USER_API + "?" + API_KEY_TEXT + "=" + API_KEY,
        data: formData);
    print(response.data['message'].toString());
    if (response.data['error'] == false) {
      Navigator.pop(context);
      AlertDialog alertDialogNew2 = AlertDialog(
        content: Container(
          height: 80,
          child: Column(
            children: [
              Text(response.data['message']),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    prefs.setBool("forgotPass", false);
                    registerPhoneController.text = "";
                    Navigator.pop(context);
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
          return alertDialogNew2;
        },
      );
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
    AlertDialog alertDialogNew = AlertDialog(
      content: Container(
        height: 80,
        child: Column(
          children: [
            Text("Password Fields is Required"),
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
}

changeName(context, String uid, File image) async {
  Navigator.pop(context);
  if (updateUserNameController.text != "") {
    showLoading(context);
    Dio dio = new Dio();
    var formData;
    if (image != null) {
      formData = FormData.fromMap({
        "name": updateUserNameController.text,
        "email": updateEmailController.text,
        "profile":
            await MultipartFile.fromFile(image.path, filename: "profile.jpg"),
        "uid": uid,
      });
    } else {
      formData = FormData.fromMap({
        "name": updateUserNameController.text,
        "email": updateEmailController.text,
        "uid": uid,
      });
    }
    var response = await dio.post(
        API_URL + UPDATE_NAME_API + "?" + API_KEY_TEXT + "=" + API_KEY,
        data: formData);
    print(response.data['message'].toString());
    if (response.data['error'] == false) {
      Navigator.pop(context);
      AlertDialog alertDialogNew2 = AlertDialog(
        content: Container(
          height: 80,
          child: Column(
            children: [
              Text(response.data['message']),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    updateUserNameController.text = "";
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
          return alertDialogNew2;
        },
      );
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
    AlertDialog alertDialogNew = AlertDialog(
      content: Container(
        height: 80,
        child: Column(
          children: [
            Text("Name Fields is Required"),
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
}

submitForm({
  required String serviceType,
  required String uid,
  required String category,
  required String subcateogry,
  required String about_service,
  required String address,
  required String documentType,
  File? aadharFrontImage,
  File? aadharBackImage,
  required File docImage,
  required File shopImage,
  required String plan,
  context,
  required LatLng location,
  required String plan_expiry_date,
  required bool terms,
  required String payment_type,
}) async {
  showLoading(context);

  Dio dio = new Dio();
  var formData;
  formData = FormData.fromMap({
    "uid": uid,
    "service_type": serviceType,
    "category": category,
    "subcategory": subcateogry,
    "about_service": about_service,
    "document_type": documentType,
    "document_image1": await MultipartFile.fromFile(aadharFrontImage!.path,
        filename: "aadharFrontImage.jpg"),
    "document_image2": await MultipartFile.fromFile(aadharBackImage!.path,
        filename: "aadharBackImage.jpg"),
    "pan_card": await MultipartFile.fromFile(docImage.path,
        filename: "otherDocImage.jpg"),
    "shop_image": await MultipartFile.fromFile(shopImage.path,
        filename: "otherShopImage.jpg"),
    "plan": plan,
    "service_loaction": address,
    "longitude": location.longitude,
    "latitude": location.latitude,
    "plan_starting_date": DateTime.now(),
    "plan_expiry_date": plan_expiry_date,
    "status": 0,
    "terms": terms,
    "postData": "",
    "payment_type": payment_type,
  });

  var response = await dio.post(
      API_URL + WORK_WITH_US_API + "?" + API_KEY_TEXT + "=" + API_KEY,
      data: formData);
  print(response.data['data']['message'].toString());
  print(response.data.toString());
  if (response.data['data']['error'] == false) {
    Navigator.pop(context);
    AlertDialog alertDialogNew = AlertDialog(
      content: Container(
        height: 80,
        child: Column(
          children: [
            Text(response.data['data']['message']),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
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
  } else {
    Navigator.pop(context);
    AlertDialog alertDialogNew = AlertDialog(
      content: Container(
        height: 80,
        child: Column(
          children: [
            Text(response.data['data']['message']),
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
}

void registerNotification() async {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  _messaging.getToken().then((value) {
    print(value);
  });
}
