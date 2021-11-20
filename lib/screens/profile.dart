import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:service_app/functions/click_functions.dart';
import 'package:service_app/functions/functions.dart';
import 'package:service_app/helper/helper.dart';
import 'package:service_app/models/PagesModal.dart';
import 'package:service_app/models/UserModal.dart';
import 'package:service_app/screens/PageViewer.dart';
import 'package:service_app/screens/work_with_us.dart';
import 'package:service_app/services/http_service.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'myservices.dart';

class ProfileScreen extends StatefulWidget {
  @override
  Social4state createState() => Social4state();
}

class Social4state extends State<ProfileScreen> {
  String? record;
  List? list;
  bool loading = true;
  bool? useMobileLayout;
  List<UserModal>? user;
  List<PagesModal>? pages;
  bool provider = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (this.mounted) {
      getUser();
    }
  }

  getUser() async {
    var prov = await Http_Service.checkProvider();
    await Http_Service.getCurerentUser().then((data) {
      setState(() {
        user = data;
        provider = prov;
      });
    });
    await Http_Service.getPages().then((pageData) {
      setState(() {
        pages = pageData;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = shortestSide < 600;
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: loading == true
            ? Center(
                child: Container(
                height: 120,
                width: 120,
                child: Lottie.asset(LOADING),
              ))
            : Column(
                children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Stack(children: <Widget>[
                          // The containers in the background
                          new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * .35,
                                  child: Stack(
                                    children: <Widget>[
                                      Opacity(
                                          opacity: 0.5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                // Box decoration takes a gradient
                                                image: DecorationImage(
                                              image: AssetImage(USER_BG),
                                            )),
                                          ))
                                    ],
                                  ),
                                ),
                              ]),

                          Positioned(
                              right: 10,
                              top: 8,
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      logout(context);
                                    },
                                    icon: Icon(Icons.login),
                                    color: Colors.white,
                                  ))),

                          new Container(
                              padding: new EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * .10,
                                  right: 20.0,
                                  left: 20.0),
                              child: new Container(
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 4.0,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 80.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.edit),
                                              splashRadius: 0.1,
                                              color: Colors.transparent,
                                            ),
                                            Text(
                                                user != null
                                                    ? user![0].name
                                                    : "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6),
                                            IconButton(
                                                onPressed: () {
                                                  updateNameModal(
                                                      context,
                                                      user != null
                                                          ? user![0].name
                                                          : "",
                                                      user![0].uid,
                                                      user![0].email,
                                                      user![0].profileImage);
                                                },
                                                icon: Icon(Icons.edit)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            user != null ? user![0].email : "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            user != null ? user![0].phone : "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ),
                              )),

                          Center(
                            child: new Container(
                              child: Card(
                                child: user != null
                                    ? user![0].profileImage == "placeholder.jpg"
                                        ? Stack(
                                            children: [
                                              CircleAvatar(
                                                maxRadius: 54.0,
                                                backgroundImage: AssetImage(
                                                    USER_PLACEHOLDER_IMAGE),
                                              ),
                                            ],
                                          )
                                        : Stack(
                                            children: [
                                              CircleAvatar(
                                                maxRadius: 54.0,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        "${IMAGE_PATH}profileImages/${user![0].profileImage}"),
                                              ),
                                            ],
                                          )
                                    : Stack(
                                        children: [
                                          CircleAvatar(
                                            maxRadius: 54.0,
                                            backgroundImage: AssetImage(
                                                USER_PLACEHOLDER_IMAGE),
                                          ),
                                        ],
                                      ),
                                elevation: 25.0,
                                shape: CircleBorder(),
                                clipBehavior: Clip.antiAlias,
                              ),
                              padding: new EdgeInsets.only(
                                  //top:useMobileLayout?
                                  // MediaQuery.of(context).size.height * .12: MediaQuery.of(context).size.height *12 ,
                                  top: useMobileLayout!
                                      ? MediaQuery.of(context).size.height * .05
                                      : MediaQuery.of(context).size.height *
                                          .15,
                                  right: 20.0,
                                  left: 20.0),
                            ),
                          ),
                        ]),
                        provider == true
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => MyServices()));
                                },
                                child: Card(
                                  color: Colors.purple,
                                  elevation: 3.0,
                                  clipBehavior: Clip.antiAlias,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      "Your Services",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => WorkWithUs()));
                                },
                                child: Card(
                                  color: Colors.purple,
                                  elevation: 3.0,
                                  clipBehavior: Clip.antiAlias,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      "Work With Us",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                        ConstrainedBox(
                          constraints: new BoxConstraints(
                            minHeight:
                                MediaQuery.of(context).size.height * 0.33,
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.33,
                          ),
                          child: ListView.builder(
                              itemCount: pages == null ? 0 : pages!.length,
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (context, index) {
                                PagesModal pageData = pages![index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) => PageViewer(
                                                title: pageData.title,
                                                content: pageData.content)));
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 3.0,
                                    clipBehavior: Clip.antiAlias,
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        pageData.title,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          launch(GOOGLE_PLAY_URL);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height * 0.082,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow.shade700,
                                size: 35,
                              ),
                              Text(
                                "Rate Us",
                                style: TextStyle(
                                    color: Colors.yellow.shade700,
                                    fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Share.share(
                              'Now Download the App "Quick for Car" If you have a Car. \n ${GOOGLE_PLAY_URL}',
                              subject: 'Quick For Car');
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height * 0.082,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.share,
                                color: Colors.purple,
                                size: 35,
                              ),
                              Text(
                                "Share App",
                                style: TextStyle(
                                    color: Colors.purple, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
      )),
    );
  }
}
