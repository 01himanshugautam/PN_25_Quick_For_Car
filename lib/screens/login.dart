import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:service_app/functions/click_functions.dart';
import 'package:service_app/functions/functions.dart';
import 'package:service_app/helper/controller.dart';
import 'package:service_app/helper/helper.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String phoneNumber = "";
  String password = "";
  var token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    FirebaseMessaging _messaging = FirebaseMessaging.instance;
    _messaging.getToken().then((value) {
      token = value.toString();
    });
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Hero(
                    tag: "background",
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(100)),
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
                            fit: BoxFit.fill,
                          )),
                    ),
                  ),
                  Center(
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
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
              height: MediaQuery.of(context).size.height * 0.67,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 30,
                    left: 10,
                    right: 10,
                  ),
                  margin: EdgeInsets.symmetric(vertical: 30),
                  height: MediaQuery.of(context).size.height * 0.7,
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
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 30, left: 10),
                        child: Text(
                          "Welcome Back ,",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IntlPhoneField(
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
                      TextField(
                        controller: loginPasswordController,
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          forgotPassword(context);
                        },
                        child: Text("Forgot Password ?"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            loginUser(context, phoneNumber, password, token);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.6,
                            alignment: Alignment.center,
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an Account ? "),
                          GestureDetector(
                            onTap: () {
                              createAccount(context);
                            },
                            child: Text(
                              "Click Here",
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        ],
                      )
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
