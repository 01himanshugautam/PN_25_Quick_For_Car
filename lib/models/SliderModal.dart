// To parse this JSON data, do
//
//     final sliderModal = sliderModalFromJson(jsonString);

import 'dart:convert';

List<SliderModal> sliderModalFromJson(String str) => List<SliderModal>.from(json.decode(str).map((x) => SliderModal.fromJson(x)));

String sliderModalToJson(List<SliderModal> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SliderModal {
  SliderModal({
    required this.id,
    required this.image,
    required this.category,
  });

  String id;
  String image;
  String category;

  factory SliderModal.fromJson(Map<String, dynamic> json) => SliderModal(
    id: json["id"],
    image: json["image"],
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "category": category,
  };
}
