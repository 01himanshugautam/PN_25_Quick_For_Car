import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:service_app/functions/click_functions.dart';
import 'package:service_app/functions/functions.dart';
import 'package:service_app/helper/helper.dart';
import 'package:service_app/models/CategoryModal.dart';
import 'package:service_app/models/SliderModal.dart';
import 'package:service_app/models/SubcategoryModal.dart';
import 'package:service_app/screens/components/CategoryListView.dart';
import 'package:service_app/screens/search_screen.dart';
import 'package:service_app/screens/service_screen_subcategory.dart';
import 'package:service_app/services/http_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;
  List<LatestCategory>? categories;
  List<SliderModal>? slider;
  List<SubcategoryModal>? subcategory;
  String address = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (this.mounted) {
      location();
      getServices();
    }
  }

  location() async {
    var loadAddress = await userLocation();
    setState(() {
      address = loadAddress;
    });
  }

  getServices() async {
    await Http_Service.getSlider().then((sliderData) {
      setState(() {
        slider = sliderData;
      });
    });
    await Http_Service.getSubCategory().then((sub) {
      setState(() {
        subcategory = sub;
      });
    });
    await Http_Service.getLatestCategory().then((category) {
      setState(() {
        categories = category;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Color> _color = [
      Color(0xFFE25141),
      Color(0xFF4154AF),
      Color(0xFFD0DA58),
      Color(0xFF9036AC),
      Color(0xFF66AC5D),
      Color(0xFFD73A63),
      Color(0xFF52B9D2),
      Color(0xFFF7C245),
      Color(0xFFEB5F5A),
      Color(0xFF419387),
      Color(0xFFF29C37),
      Color(0xFF735649),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 5,
        actions: [
          Container(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SearchScreen()));
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ))),
        ],
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () {
                    location();
                  },
                  icon: Icon(
                    Icons.location_searching,
                    color: Colors.black54,
                    size: 18,
                  )),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                height: 30,
                width: MediaQuery.of(context).size.width * 0.6,
                alignment: Alignment.centerLeft,
                child: Text(
                  address,
                  style: TextStyle(fontSize: 10, color: Colors.blue),
                  maxLines: 2,
                )),
          ],
        ),
      ),
      body: loading
          ? Center(
              child: Container(
              height: 120,
              width: 120,
              child: Lottie.asset(LOADING),
            ))
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    height: 200.0,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: slider != null
                        ? Carousel(
                            images: [
                              for (var i = 0; i < slider!.length; i++)
                                NetworkImage(
                                    "${IMAGE_PATH}slider/${slider![i].image}"),
                            ],
                            dotSize: 4.0,
                            dotSpacing: 15.0,
                            dotColor: Colors.grey,
                            indicatorBgPadding: 5.0,
                            dotBgColor: Colors.blue.withOpacity(0.5),
                            borderRadius: false,
                            autoplayDuration: Duration(seconds: 3),
                            dotHorizontalPadding: 20,
                          )
                        : SizedBox(),
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              "Services",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListView.builder(
                              itemCount:
                                  categories == null ? 0 : categories!.length,
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                LatestCategory category = categories![index];
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: CategoryListView(
                                    title: category.name,
                                    id: category.id,
                                    image: category.image,
                                  ),
                                );
                              }),
                        ],
                      )),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          "Brands",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                          shrinkWrap: true,
                          primary: false,
                          padding: EdgeInsets.all(10),
                          children: List.generate(
                            subcategory == null ? 0 : subcategory!.length,
                            (index) {
                              SubcategoryModal sub = subcategory![index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ServiceScreen2(
                                              id: int.parse(sub.id),
                                              name: sub.name)));
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          new BoxShadow(
                                            color: Colors.black38,
                                            blurRadius: 5.0,
                                          ),
                                        ],
                                        color: Colors.white,
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                IMAGE_PATH +
                                                    "category/" +
                                                    sub.image),
                                            fit: BoxFit.fill),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
