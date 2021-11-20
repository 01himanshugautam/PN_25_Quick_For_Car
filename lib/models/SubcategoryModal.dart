// To parse this JSON data, do
//
//     final subcategoryModal = subcategoryModalFromJson(jsonString);

import 'dart:convert';

List<SubcategoryModal> subcategoryModalFromJson(String str) => List<SubcategoryModal>.from(json.decode(str).map((x) => SubcategoryModal.fromJson(x)));

String subcategoryModalToJson(List<SubcategoryModal> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubcategoryModal {
  SubcategoryModal({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.status,
  });

  String id;
  String name;
  String image;
  String category;
  String status;

  factory SubcategoryModal.fromJson(Map<String, dynamic> json) => SubcategoryModal(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    category: json["category"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "category": category,
    "status": status,
  };
}
