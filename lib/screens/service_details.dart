import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_app/functions/click_functions.dart';
import 'package:service_app/helper/helper.dart';
import 'package:service_app/models/workWithUsModal.dart';
import 'package:url_launcher/url_launcher.dart';

import 'map_screen.dart';

class ServiceDetails extends StatefulWidget {
  ServiceDetails({Key? key, required this.data}) : super(key: key);

  WorkWithUs data;

  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  LatLng? userLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (this.mounted) {
      getLocation();
    }
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
        title: Text(widget.data.serviceType),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InteractiveViewer(
                panEnabled: false, // Set it to false
                boundaryMargin: EdgeInsets.all(100),
                minScale: 0.5,
                maxScale: 2,
                child: Hero(
                  tag: widget.data.shopImage,
                  child: Image.network(
                    "${IMAGE_PATH}documents/${widget.data.shopImage}",
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Hero(
                tag: widget.data.phone,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        launch("tel:${widget.data.phone}");
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 50,
                              width: 50,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Center(
                                  child:
                                      Icon(Icons.call, color: Colors.white))),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Call")
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        launch("mailto:${widget.data.email}");
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 50,
                              width: 50,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Center(
                                  child:
                                      Icon(Icons.mail, color: Colors.white))),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Mail")
                        ],
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MapScreen(
                                      position: LatLng(
                                          double.parse(widget.data.latitude),
                                          double.parse(widget.data.longitude)),
                                      name: widget.data.name,
                                      userLocation: userLocation!)));
                        },
                        child: Column(
                          children: [
                            Container(
                                height: 50,
                                width: 50,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Center(
                                    child: Image.asset(
                                  "assets/images/ic_cart_address.png",
                                  height: 30,
                                  width: 30,
                                ))),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Location")
                          ],
                        )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  widget.data.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Address:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.data.address,
                      maxLines: 3,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phone:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        launch("tel:${widget.data.phone}");
                      },
                      child: Text(
                        widget.data.phone,
                        maxLines: 3,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        launch("mailto:${widget.data.email}");
                      },
                      child: Text(
                        widget.data.email,
                        maxLines: 3,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.data.aboutService,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
