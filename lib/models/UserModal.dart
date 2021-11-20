// To parse this JSON data, do
//
//     final latestCategory = latestCategoryFromJson(jsonString);

import 'dart:convert';

List<UserModal> currentUserFromJson(String str) => List<UserModal>.from(json.decode(str).map((x) => UserModal.fromJson(x)));

String currentUserToJson(List<UserModal> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModal {
  UserModal({
    required this.id,
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.profileImage,
    required this.password,
    required this.service_provider,
    required this.status,
  });

  String id;
  String uid;
  String name;
  String email;
  String phone;
  String address;
  String longitude;
  String latitude;
  String profileImage;
  String password;
  String service_provider;
  String status;

  factory UserModal.fromJson(Map<String, dynamic> json) => UserModal(
    id: json["id"],
    uid: json["uid"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    address: json["address"],
    longitude: json["lng"],
    latitude: json["lat"],
    profileImage: json["profileImage"],
    password: json["password"],
    service_provider: json["service_provider"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "name": name,
    "email": email,
    "phone": phone,
    "address": address,
    "lng": longitude,
    "lat": latitude,
    "profileImage": profileImage,
    "password": password,
    "service_provider":service_provider,
    "status": status,
  };
}
