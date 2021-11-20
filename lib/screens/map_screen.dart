import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_polyline_draw/map_polyline_draw.dart';
import 'package:service_app/helper/helper.dart';
import "package:polyline/polyline.dart";

class MapScreen extends StatefulWidget {

   LatLng position;
  String name;
   LatLng userLocation;
  MapScreen({required this.position ,required this.name ,required this.userLocation});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: SafeArea(
        child:MapPolyLineDraw(
          apiKey: GOOGLE_MAP_KEY,
          firstPoint:MapPoint(widget.userLocation.latitude, widget.userLocation.longitude),
          secondPoint:MapPoint(widget.position.latitude, widget.position.longitude),
          mapZoom: 15,
          myLocationEnabled: true,
          markerOneInfoText: "Your Location",
          markerTwoInfoText: "Your Destination",
        ),
      ),
    );
  }
}
// AIzaSyDObvzMlwzOFBPKClvaGhhR96NvKhzrgAc