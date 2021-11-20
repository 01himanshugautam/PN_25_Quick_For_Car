import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PageViewer extends StatelessWidget {
  PageViewer({required this.title,required this.content});
  String title;
  String content;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
          physics: BouncingScrollPhysics(),
          child: SafeArea(child:Html(data: content,
          ),)),
    );
  }
}
