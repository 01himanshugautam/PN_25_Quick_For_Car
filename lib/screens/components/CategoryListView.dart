import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:service_app/helper/helper.dart';
import 'package:service_app/screens/services.dart';

class CategoryListView extends StatelessWidget {
  String title;
  String image;
  String id;
  CategoryListView(
      {required this.id, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ServiceScreen(
                      id: id,
                      name: title,
                    )));
      },
      child: Stack(alignment: Alignment.center, children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width,
          height: 160,
          decoration: BoxDecoration(
              boxShadow: [
                new BoxShadow(
                  color: Colors.black54,
                  blurRadius: 8.0,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      IMAGE_PATH + "category/" + image),
                  fit: BoxFit.fill)),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black87.withOpacity(0.6),
          ),
        ),
        Text(title,
            style: TextStyle(fontSize: 35, color: Colors.white),
            textAlign: TextAlign.center),
      ]),
    );
  }
}
