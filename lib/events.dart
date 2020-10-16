import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';

class Events extends StatefulWidget {

  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Events> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: HexColor("#EDEBE6"),

    body: Center(
    child: Text(
    "events",
    style: TextStyle(fontSize: 30.0, color: HexColor("#819EA6")),
    ),
    ),

    );










  }










}






