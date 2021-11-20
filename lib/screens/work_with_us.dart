import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:service_app/functions/click_functions.dart';
import 'package:service_app/functions/functions.dart';
import 'package:service_app/helper/controller.dart';
import 'package:service_app/helper/helper.dart';
import 'package:service_app/models/UserModal.dart';
import 'package:service_app/screens/profile.dart';
import 'package:service_app/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkWithUs extends StatefulWidget {
  @override
  _WorkWithUsState createState() => _WorkWithUsState();
}

class _WorkWithUsState extends State<WorkWithUs> {
  final picker = ImagePicker();
  String? uid;
  String? serviceType;
  String? selectedCategory;
  String? selectedSubCateogry;
  String? selectedDocument;
  List? categories;
  List? subcategories;
  List? plans;
  String? selectedPlan;
  String? address;
  File? aadhar_card_front_image;
  File? aadhar_card_back_image;
  File? card_image;
  File? shop_image;
  LatLng? locationPosition;
  Razorpay? _razorpay;
  bool? terms;
  String? planValidity;
  List<UserModal>? user;
  var price;
  var newDate;
  String payment_type = "Cash";

  Future getAadharFrontImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        aadhar_card_front_image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getAadharBackImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        aadhar_card_back_image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getCardImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        card_image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getShopImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        shop_image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  getCurrentUser() async {
    var prefs = await SharedPreferences.getInstance();
    await Http_Service.getCurerentUser().then((data) {
      setState(() {
        uid = prefs.getString("uid");
        user = data;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getData();
    location();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print(response.orderId);
    submitForm(
      serviceType: serviceType.toString(),
      uid: uid.toString(),
      category: selectedCategory.toString(),
      subcateogry: selectedSubCateogry.toString(),
      about_service: aboutServiceController.text,
      address: address!,
      documentType: selectedDocument.toString(),
      aadharFrontImage: File(aadhar_card_front_image!.path),
      aadharBackImage: File(aadhar_card_back_image!.path),
      docImage: File(card_image!.path),
      shopImage: File(shop_image!.path),
      plan: selectedPlan.toString(),
      context: context,
      location: locationPosition!,
      plan_expiry_date: newDate.toString(),
      terms: terms!,
      payment_type: payment_type,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print(response);
    AlertDialog alertDialogNew = AlertDialog(
      content: Container(
        height: 80,
        child: Column(
          children: [
            Text("Payment Failed Try Again"),
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

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print(response);
  }

  makePayment() async {
    AlertDialog alertDialogNew;
    if (serviceType == null ||
        aboutServiceController.text == "" ||
        serviceLocationConroller.text == "" ||
        selectedPlan == null) {
      alertDialogNew = AlertDialog(
        content: Container(
          height: 80,
          child: Column(
            children: [
              Text("All Fields is Required"),
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
    } else {
      if (aadhar_card_back_image == null &&
          aadhar_card_front_image == null &&
          card_image == null &&
          shop_image == null) {
        alertDialogNew = AlertDialog(
          content: Container(
            height: 80,
            child: Column(
              children: [
                Text("Please Select All Documents And Image"),
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
      } else {
        if (terms == true) {
          var options = {
            'key': RAZORPAY_KEY,
            'amount': int.parse(price) * 100,
            'name': user![0].name,
            'description': 'Work With Us Charges',
            'prefill': {
              'contact': user![0].phone,
              'email': user![0].email,
            },
            "external": {
              "wallets": ['paytm'],
            }
          };
          try {
            print('1');
            _razorpay!.open(options);
            print('2');
          } catch (e) {
            print('error');
            debugPrint(e.toString());
          }
        } else {
          alertDialogNew = AlertDialog(
            content: Container(
              height: 100,
              child: Column(
                children: [
                  Text("Please Accept The Terms & Conditions."),
                  SizedBox(
                    height: 12,
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
    }
  }

  location() async {
    var loadAddress = await userLocation();
    var position = await getCurrentPosition();
    setState(() {
      address = loadAddress;
      locationPosition = position;
    });
    serviceLocationConroller.text = loadAddress.toString();
  }

  getData() async {
    await Http_Service.getListofCategory().then((value) {
      setState(() {
        selectedDocument = "Pan Card";
        categories = json.decode(value);
      });
    });
    await Http_Service.getListofSubcategories().then((value) {
      print(value.toString());
      setState(() {
        subcategories = json.decode(value);
      });
    });

    await Http_Service.getListofPlans().then((value) {
      print(value.toString());
      setState(() {
        plans = json.decode(value);
      });
    });
  }

  List<String> types = [
    'General Service',
    'Towing Service',
    'Alignment Shop',
    'Car Washing'
  ]; // Option 2
  List<String> documents = [
    'Aadhar Card',
    'Pan Card',
    'Business Card'
  ]; // Option 2

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Work With Us"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.black54,
                      blurRadius: 2.0,
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text(
                        'Please choose a Service'), // Not necessary for Option 1
                    value: serviceType,
                    isExpanded: true,
                    onChanged: (newValue) {
                      setState(() {
                        serviceType = newValue as String?;
                      });
                    },
                    items: types.map((location) {
                      return DropdownMenuItem(
                        child: new Text(location),
                        value: location,
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                child: serviceType == "General Service"
                    ? Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin:
                                EdgeInsets.only(top: 10, left: 10, right: 10),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: Text(
                                    'Please choose a Category'), // Not necessary for Option 1
                                value: selectedCategory,
                                isExpanded: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedCategory = newValue.toString();
                                  });
                                },
                                items: categories?.map((category) {
                                  return DropdownMenuItem(
                                    child: new Text(category['name']),
                                    value: category['id'].toString(),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin:
                                EdgeInsets.only(top: 10, left: 10, right: 10),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: Text(
                                    'Please Choose a Brand'), // Not necessary for Option 1
                                value: selectedSubCateogry,
                                isExpanded: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedSubCateogry = newValue.toString();
                                  });
                                },
                                items: subcategories?.map((subcategory) {
                                  return DropdownMenuItem(
                                    child: new Text(subcategory['name']),
                                    value: subcategory['id'].toString(),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: serviceType == "Alignment Shop"
                            ? Text(
                                "About Your Shop",
                                textAlign: TextAlign.left,
                              )
                            : Text(
                                "About Your Service",
                                textAlign: TextAlign.left,
                              )),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black54,
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                      child: TextField(
                        minLines: 5,
                        maxLines: 5,
                        controller: aboutServiceController,
                        cursorColor: Colors.black,
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Enter here...",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: serviceType == "Alignment Shop"
                            ? Text(
                                "Shop Address",
                                textAlign: TextAlign.left,
                              )
                            : Text(
                                "Service Address",
                                textAlign: TextAlign.left,
                              )),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black54,
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              minLines: 1,
                              maxLines: 1,
                              controller: serviceLocationConroller,
                              cursorColor: Colors.black,
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                hintText: "Enter here...",
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                              child: IconButton(
                                  onPressed: () {
                                    location();
                                  },
                                  icon: Icon(Icons.location_searching))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                  top: 10,
                  left: 10,
                ),
                child: Text(
                  "Aadhar Card",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: InkWell(
                        onTap: () {
                          getAadharFrontImage();
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: aadhar_card_front_image != null
                                  ? Image.file(aadhar_card_front_image!)
                                  : Image.asset(IMAGE_PLACEHOLDER_IMAGE),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              padding: EdgeInsets.all(15),
                              child: Text("Pick Aadhar Front Image"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: InkWell(
                        onTap: () {
                          getAadharBackImage();
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: aadhar_card_back_image != null
                                  ? Image.file(aadhar_card_back_image!)
                                  : Image.asset(IMAGE_PLACEHOLDER_IMAGE),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              padding: EdgeInsets.all(15),
                              child: Text("Pick Aadhar Back Image"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                  top: 10,
                  left: 10,
                ),
                child: Text(
                  "Pan Card",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: InkWell(
                        onTap: () {
                          getCardImage();
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: card_image != null
                                  ? Image.file(card_image!)
                                  : Image.asset(IMAGE_PLACEHOLDER_IMAGE),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              padding: EdgeInsets.all(15),
                              child: Text("Pick Pan Card Image"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                  top: 10,
                  left: 10,
                ),
                child: Text(
                  "Business Info",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: InkWell(
                        onTap: () {
                          getShopImage();
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: shop_image != null
                                  ? Image.file(shop_image!)
                                  : Image.asset(IMAGE_PLACEHOLDER_IMAGE),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              padding: EdgeInsets.all(15),
                              child: Text("Pick Business Card OR Shop Image"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.black54,
                      blurRadius: 2.0,
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text('Select Plans'), // Not necessary for Option 1
                    value: selectedPlan,
                    isExpanded: true,
                    onChanged: (newValue) {
                      setState(() {
                        selectedPlan = newValue as String?;
                      });

                      if (plans != null) {
                        for (int i = 0; i < plans!.length; i++) {
                          if (plans![i]['id'] == selectedPlan) {
                            var date = DateTime.now();
                            var dateNew;
                            if (plans![i]['type'] == "Years") {
                              dateNew = new DateTime(
                                  date.year + int.parse(plans![i]['validity']),
                                  date.month,
                                  date.day);
                            } else {
                              dateNew = new DateTime(
                                  date.year,
                                  date.month + int.parse(plans![i]['validity']),
                                  date.day);
                            }
                            setState(() {
                              price = plans![i]['price'];
                              newDate = dateNew;
                            });
                          }
                        }
                      }
                    },
                    items: plans?.map((plan) {
                      return DropdownMenuItem(
                        child: new Text(plan['name'] +
                            " ( Rs." +
                            plan['price'] +
                            " ) " +
                            plan['validity'] +
                            "/" +
                            plan['type']),
                        value: plan['id'],
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Payment Offline'),
                      leading: Radio(
                        value: "Cash",
                        groupValue: payment_type,
                        onChanged: (value) {
                          setState(() {
                            payment_type = value.toString();
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Payment Online'),
                      leading: Radio(
                        value: "Razorpay",
                        groupValue: payment_type,
                        onChanged: (value) {
                          setState(() {
                            payment_type = value.toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  new Checkbox(
                      value: terms != null ? terms : false,
                      activeColor: Colors.blue,
                      onChanged: (newValue) {
                        setState(() {
                          terms = newValue;
                        });
                      }),
                  Row(
                    children: [
                      Text('Agree With'),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Terms & Conditions',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (payment_type == "Razorpay") {
                      makePayment();
                    } else {
                      submitForm(
                        serviceType: serviceType.toString(),
                        uid: uid.toString(),
                        category: selectedCategory.toString(),
                        subcateogry: selectedSubCateogry.toString(),
                        about_service: aboutServiceController.text,
                        address: address!,
                        documentType: selectedDocument.toString(),
                        aadharFrontImage: File(aadhar_card_front_image!.path),
                        aadharBackImage: File(aadhar_card_back_image!.path),
                        docImage: File(card_image!.path),
                        shopImage: File(shop_image!.path),
                        plan: selectedPlan.toString(),
                        context: context,
                        location: locationPosition!,
                        plan_expiry_date: newDate.toString(),
                        terms: terms!,
                        payment_type: payment_type,
                      );
                    }
                  },
                  child: Text("Pay Now"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
