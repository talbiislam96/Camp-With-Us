import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Article extends StatefulWidget {

  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: HexColor("#EDEBE6"),


      body: Center(
        child: Text(
          "items",
          style: TextStyle(fontSize: 30.0, color: HexColor("#819EA6")),
        ),
      ),

    );
  }
}