import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_app/functions/click_functions.dart';
import 'package:service_app/screens/map_screen.dart';
import 'package:service_app/screens/service_details.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';
import 'package:service_app/helper/helper.dart';
import 'package:service_app/models/workWithUsModal.dart';
import 'package:service_app/services/http_service.dart';

class WashingScreen extends StatefulWidget {
  const WashingScreen({Key? key}) : super(key: key);

  @override
  _WashingScreenState createState() => _WashingScreenState();
}

class _WashingScreenState extends State<WashingScreen> {
  List<WorkWithUs>? workWithUsData;
  bool loading = true;
  LatLng? userLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (this.mounted) {
      getData();
      getLocation();
    }
  }

  getData() {
    Http_Service.getWorkWithUsWashing().then((data) {
      print(data);
      setState(() {
        workWithUsData = data;
        loading = false;
      });
    });
  }

  getLocation() async {
    LatLng position = await getCurrentPosition();
    setState(() {
      userLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Car Washing"),
        backgroundColor: Colors.indigo,
      ),
      body: loading != true
          ? SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  workWithUsData != null && workWithUsData!.length != 0
                      ? ListView.builder(
                          itemCount: workWithUsData == null
                              ? 0
                              : workWithUsData!.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            WorkWithUs data = workWithUsData![index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            ServiceDetails(data: data)));
                              },
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  child: Row(
                                    children: [
                                      Hero(
                                        tag: data.shopImage,
                                        child: Container(
                                          width: 100,
                                          height: 130,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: NetworkImage(
                                                "${IMAGE_PATH}documents/${data.shopImage}"),
                                            fit: BoxFit.cover,
                                          )),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                              maxLines: 2,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  size: 16,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.55,
                                                  child: Text(
                                                    "${data.address}",
                                                    maxLines: 2,
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    launch("tel:${data.phone}");
                                                  },
                                                  child: Container(
                                                      height: 50,
                                                      width: 50,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25)),
                                                      child: Center(
                                                          child: Icon(
                                                              Icons.call,
                                                              color: Colors
                                                                  .white))),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    launch(
                                                        "mailto:${data.email}");
                                                  },
                                                  child: Container(
                                                      height: 50,
                                                      width: 50,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25)),
                                                      child: Center(
                                                          child: Icon(
                                                              Icons.mail,
                                                              color: Colors
                                                                  .white))),
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) => MapScreen(
                                                                  position: LatLng(
                                                                      double.parse(data
                                                                          .latitude),
                                                                      double.parse(data
                                                                          .longitude)),
                                                                  name:
                                                                      data.name,
                                                                  userLocation:
                                                                      userLocation!)));
                                                    },
                                                    child: Container(
                                                        height: 50,
                                                        width: 50,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Colors.orange,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25)),
                                                        child: Center(
                                                            child: Image.asset(
                                                          "assets/images/ic_cart_address.png",
                                                          height: 30,
                                                          width: 30,
                                                        )))),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                      : Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                              child: Text(
                            "No Service Available Near You.",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                        ),
                ],
              ),
            )
          : Center(
              child: Container(
              height: 120,
              width: 120,
              child: Lottie.asset(LOADING),
            )),
    );
  }
}
