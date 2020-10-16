import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';

class Article extends StatefulWidget {

  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Hexcolor("#EDEBE6"),
      appBar: AppBar(
        backgroundColor: Hexcolor("#819EA6"),
        actions: <Widget>[
        ],
      ),
      body: Center(
        child: Text(
          "WelCome",
          style: TextStyle(fontSize: 30.0, color: Hexcolor("#819EA6")),
        ),
      ),

    );










  }










}