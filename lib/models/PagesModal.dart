// To parse this JSON data, do
//
//     final pagesModal = pagesModalFromJson(jsonString);

import 'dart:convert';

List<PagesModal> pagesModalFromJson(String str) => List<PagesModal>.from(json.decode(str).map((x) => PagesModal.fromJson(x)));

String pagesModalToJson(List<PagesModal> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PagesModal {
  PagesModal({
    required this.id,
    required this.title,
    required this.content,
    required this.status,
  });

  String id;
  String title;
  String content;
  String status;

  factory PagesModal.fromJson(Map<String, dynamic> json) => PagesModal(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "status": status,
  };
}
