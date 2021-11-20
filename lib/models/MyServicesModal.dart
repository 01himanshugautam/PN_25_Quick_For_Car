// To parse this JSON data, do
//
//     final myServicesModal = myServicesModalFromJson(jsonString);

import 'dart:convert';

List<MyServicesModal> myServicesModalFromJson(String str) => List<MyServicesModal>.from(json.decode(str).map((x) => MyServicesModal.fromJson(x)));

String myServicesModalToJson(List<MyServicesModal> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyServicesModal {
  MyServicesModal({
    required this.id,
    required this.uid,
    required this.serviceType,
    required this.category,
    required this.subcategory,
    required this.aboutService,
    required this.documentType,
    required this.documentImage1,
    required this.documentImage2,
    required this.panCard,
    required this.shopImage,
    required this.plan,
    required this.serviceLoaction,
    required this.longitude,
    required this.latitude,
    required this.planStartingDate,
    required this.planExpiryDate,
    required this.status,
    required this.terms,
    required this.name,
    required this.image,
  });

  String id;
  String uid;
  String serviceType;
  String category;
  String subcategory;
  String aboutService;
  String documentType;
  String documentImage1;
  String documentImage2;
  String panCard;
  String shopImage;
  String plan;
  String serviceLoaction;
  String longitude;
  String latitude;
  DateTime planStartingDate;
  DateTime planExpiryDate;
  String status;
  String terms;
  String name;
  String image;

  factory MyServicesModal.fromJson(Map<String, dynamic> json) => MyServicesModal(
    id: json["id"],
    uid: json["uid"],
    serviceType: json["service_type"],
    category: json["category"],
    subcategory: json["subcategory"],
    aboutService: json["about_service"],
    documentType: json["document_type"],
    documentImage1: json["document_image1"],
    documentImage2: json["document_image2"],
    panCard: json["pan_card"],
    shopImage: json["shop_image"],
    plan: json["plan"],
    serviceLoaction: json["service_loaction"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    planStartingDate: DateTime.parse(json["plan_starting_date"]),
    planExpiryDate: DateTime.parse(json["plan_expiry_date"]),
    status: json["status"],
    terms: json["terms"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "service_type": serviceType,
    "category": category,
    "subcategory": subcategory,
    "about_service": aboutService,
    "document_type": documentType,
    "document_image1": documentImage1,
    "document_image2": documentImage2,
    "pan_card": panCard,
    "shop_image": shopImage,
    "plan": plan,
    "service_loaction": serviceLoaction,
    "longitude": longitude,
    "latitude": latitude,
    "plan_starting_date": planStartingDate.toIso8601String(),
    "plan_expiry_date": planExpiryDate.toIso8601String(),
    "status": status,
    "terms": terms,
    "name": name,
    "image": image,
  };
}
