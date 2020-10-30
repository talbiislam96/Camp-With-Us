import 'package:camp_with_us/Entity/following.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:camp_with_us/locale_time_toolkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:camp_with_us/screens/trending.dart';
import 'package:camp_with_us/util/categories.dart';
import 'package:camp_with_us/util/friends.dart';
import 'package:camp_with_us/widgets/category_item.dart';
import 'package:camp_with_us/widgets/search_card.dart';
import 'package:camp_with_us/widgets/slide_item.dart';

import '../Entity/event.dart';




class EventDetails extends StatefulWidget {
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
                child: Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 15.0,
                )),
            Expanded(
                child: Text(
                  'Location ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
            Expanded(
                child: Icon(
                  Icons.directions_car,
                  color: Colors.white,
                  size: 15.0,
                )),
            Expanded(
                child: Text(
                  'distance ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
          ],
        ),
        const Divider(
          height: 20,
          thickness: 2,
          indent: 20,
          endIndent: 20,
          color: Colors.white,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 15.0,
                )),
            Expanded(
                child: Text(
                  'Start Date ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
            Expanded(
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 15.0,
                )),
            Expanded(
                child: Text(
                  'End Date ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
          ],
        ),
        const Divider(
          height: 20,
          thickness: 2,
          indent: 20,
          endIndent: 20,
          color: Colors.white,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: Icon(
                  Icons.phone_iphone,
                  color: Colors.white,
                  size: 15.0,
                )),
            Expanded(
                child: Text(
                  'mobile number',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
          ],
        ),
        const Divider(
          height: 20,
          thickness: 2,
          indent: 20,
          endIndent: 20,
          color: Colors.white,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: Icon(
                  Icons.people,
                  color: Colors.white,
                  size: 15.0,
                )),
            Expanded(
                child: Text(
                  'number of participants',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
          ],
        ),
        const Divider(
          height: 20,
          thickness: 2,
          indent: 20,
          endIndent: 20,
          color: Colors.white,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: Icon(
                  Icons.attach_money,
                  color: Colors.white,
                  size: 15.0,
                )),
            Expanded(
                child: Text(
                  'Price',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/logo.png"),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );
    final rating = Row(
      children: <Widget>[
        Flexible(
          child: Icon(
            Icons.star,
            color: Colors.yellow,
            size: 30,
          ),
        ),
        Flexible(
          child: Icon(
            Icons.star,
            color: Colors.yellow,
            size: 30,
          ),
        ),
        Flexible(
          child: Icon(
            Icons.star,
            color: Colors.yellow,
            size: 30,
          ),
        ),
        Flexible(
          child: Icon(
            Icons.star,
            color: Colors.yellow,
            size: 30,
          ),
        ),
        Flexible(
          child: Icon(
            Icons.star,
            color: Colors.yellow,
            size: 30,
          ),
        ),
      ],
    );
    final bottomContentText = Text(
      'Description : Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor  ',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
    final readButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () => {},
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child: Text("participate", style: TextStyle(color: Colors.white)),
        ));
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[
            bottomContentText,
            readButton,
            Row(
              children: <Widget>[
                Expanded(
                  child: Icon(
                    Icons.favorite,
                    color: Colors.pinkAccent,
                    size: 30.0,
                  ),
                ),
                Expanded(
                  child: rating,
                )
              ],
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }
}