import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:service_app/functions/click_functions.dart';
import 'package:service_app/helper/controller.dart';
import 'package:service_app/helper/helper.dart';
import 'package:service_app/models/workWithUsModal.dart';
import 'package:service_app/screens/service_details.dart';
import 'package:service_app/services/http_service.dart';
import 'package:url_launcher/url_launcher.dart';

import 'map_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<WorkWithUs>? searchData;
  LatLng? userLocation;
  bool loading = true;
  String search = "";

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.text = "";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  getLocation() async {
    await Http_Service.searchData("s").then((value) {
      setState(() {
        searchData = value;
        loading = false;
      });
    });

    var position = await getCurrentPosition();
    setState(() {
      userLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.grey,
                    )
                  ]),
              child: Row(
                children: [
                  Container(
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back))),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.68,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      minLines: 1,
                      maxLines: 1,
                      controller: searchController,
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          loading = true;
                          search = value;
                        });
                        Http_Service.searchData(search).then((data) {
                          setState(() {
                            searchData = data;
                            loading = false;
                          });
                        });
                      },
                      cursorColor: Colors.black,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: "Search...",
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
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            await Http_Service.searchData(searchController.text)
                                .then((value) {
                              setState(() {
                                searchData = value;
                                loading = false;
                              });
                            });
                          },
                          icon: Icon(Icons.search))),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.86,
              child: loading != true
                  ? SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          searchData != null && searchData!.length != 0
                              ? ListView.builder(
                                  itemCount: searchData == null
                                      ? 0
                                      : searchData!.length,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemBuilder: (context, index) {
                                    WorkWithUs data = searchData![index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ServiceDetails(
                                                    data: data)));
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
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data.name,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                      maxLines: 2,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          Icons.location_on,
                                                          size: 16,
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.55,
                                                          child: Text(
                                                            "${data.address}",
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                fontSize: 10),
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
                                                            launch(
                                                                "tel:${data.phone}");
                                                          },
                                                          child: Container(
                                                              height: 50,
                                                              width: 50,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .green,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25)),
                                                              child: Center(
                                                                  child: Icon(
                                                                      Icons
                                                                          .call,
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
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25)),
                                                              child: Center(
                                                                  child: Icon(
                                                                      Icons
                                                                          .mail,
                                                                      color: Colors
                                                                          .white))),
                                                        ),
                                                        InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (_) =>
                                                                          MapScreen(
                                                                            position:
                                                                                LatLng(double.parse(data.latitude), double.parse(data.longitude)),
                                                                            name:
                                                                                data.name,
                                                                            userLocation:
                                                                                userLocation!,
                                                                          )));
                                                            },
                                                            child: Container(
                                                                height: 50,
                                                                width: 50,
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .orange,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25)),
                                                                child: Center(
                                                                    child: Image
                                                                        .asset(
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                        ],
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.86,
                      child: Center(
                          child: Container(
                        height: 120,
                        width: 120,
                        child: Lottie.asset(LOADING),
                      ))),
            ),
          ],
        ),
      ),
    ));
  }
}
