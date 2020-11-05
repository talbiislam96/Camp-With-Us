import 'package:camp_with_us/widgets/event_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:flutter/material.dart';
import 'dart:math';

class AddEventPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AddEventPageState();
}

class AddEventPageState extends State<AddEventPage> {
  void Function(Map<String,String> p1) get submitForm => null;


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
    appBar: new AppBar
      (title:
    new Text(
        "Add Your Event",
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w800,
      ),

    ),),
    body: new EditEventForm(submitForm, null),
    );
  }
}

