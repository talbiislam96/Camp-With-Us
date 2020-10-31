import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AddEventPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AddEventPageState();
}

class AddEventPageState extends State<AddEventPage>  {
  @override
  Widget build(BuildContext context) {


    return new Scaffold(
        appBar: new AppBar(title: new Text("Add Event"),),
        body: new EditEventForm(submitForm, null)
    );


  }
}