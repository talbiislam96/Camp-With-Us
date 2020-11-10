import 'dart:io';

import 'package:camp_with_us/Entity/event.dart';
import 'package:camp_with_us/WeatherAPI/servicesWeather/weather.dart';
import 'package:camp_with_us/screens/event_details.dart';
import 'package:camp_with_us/widgets/event_detail_header.dart';
import 'package:flutter/material.dart';
import 'package:camp_with_us/util/const.dart';
import 'package:camp_with_us/screens/events.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class SlideItem extends StatefulWidget {
  final int id;
  final String img;
  final String title;
  final String address;
  final String rating;
  final String date;
  final Event event;


  SlideItem({
    Key key,
    @required this.id,
    @required this.img,
    @required this.title,
    @required this.address,
    @required this.rating,
    @required this.date,
    this.event,


  }) : super(key: key);

  @override
  _SlideItemState createState() => _SlideItemState();
}

class _SlideItemState extends State<SlideItem> {
  savePref(int id) async {
    print("event clicked");
    print(id);
    SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt("idEvent", id);
      preferences.commit();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 2.9,
        width: MediaQuery.of(context).size.width / 1.2,
        child: GestureDetector(
          onTap: (){
            savePref(widget.id);
            //getLocationData();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return EventDetailsPage(widget.id);
                },
              ),
            );
          },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            elevation: 3.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 3.7,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),


                        child: Image.file(
                        File(
                           'Users/macbookpro/Desktop/ProjetFlutter/API/${widget.img}' ?? 'Users/macbookpro/Desktop/Camp-With-Us/assets/logo.png'),
                         fit: BoxFit.fill,
                        ),
                        //child: Image.asset('assets/backgroundProfile.jpg',
                          //fit: BoxFit.cover,


                       // ),


                      ),
                    ),
                    Positioned(
                      top: 6.0,
                      right: 6.0,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Constants.ratingBG,
                                size: 10,
                              ),
                              Text(
                                " ${widget.rating} ",
                                style: TextStyle(
                                  fontSize: 10.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6.0,
                      left: 6.0,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0)),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            " OPEN ",
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7.0),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "${widget.title}",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(height: 7.0),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Icon(
                          Icons.place,
                          color: Colors.red,
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "${widget.address}",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7.0),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "${widget.date}",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
