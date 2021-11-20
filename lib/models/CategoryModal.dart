// To parse this JSON data, do
//
//     final latestCategory = latestCategoryFromJson(jsonString);

import 'dart:convert';

List<LatestCategory> latestCategoryFromJson(String str) => List<LatestCategory>.from(json.decode(str).map((x) => LatestCategory.fromJson(x)));

String latestCategoryToJson(List<LatestCategory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LatestCategory {
  LatestCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
  });

  String id;
  String name;
  String image;
  String status;

  factory LatestCategory.fromJson(Map<String, dynamic> json) => LatestCategory(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "status": status,
  };
}
