import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:camp_with_us/locale_time_toolkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'Entity/event.dart';

class Events extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Events> {
  List<Event> _events = List<Event>();
  File _image;
  String imageEvent;

 // _image = File("Users/macbookpro/Desktop/ProjetFlutter/API/$imageEvent");

  Future<List<Event>> fetchEvents() async {
    var response = await http.get(
        Uri.encodeFull("http://localhost:1337/evenement/show"),
        headers: {"Accept": "application/json"});
    var events = List<Event>();

    if (response.statusCode == 200) {
      var eventsJson = json.decode(response.body);
      print(eventsJson);
      for (var eventJson in eventsJson) {
        events.add(Event.fromJson(eventJson));
      }
    }
    return events;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchEvents().then((value){
      setState(() {
        _events.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    File _image;
    String imageEvent;
    Locale myLocale = Localizations.localeOf(context);
    String localeDateFormatter = getLocaleDateFormatter(myLocale);
    initializeDateFormatting(localeDateFormatter);


    return Scaffold(
      backgroundColor: HexColor("#819EA6"),
      body: Container(
        decoration: BoxDecoration(
          color: HexColor("#EDEBE6"),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: ListView.builder(
                        padding: EdgeInsets.only(top: 0),
                        itemCount: _events.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                              top: 10,
                              left: 4,
                              right: 4,
                            ),
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 10, right: 10),
                            decoration: BoxDecoration(
                                color: HexColor("#819EA6"),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                boxShadow: [
                                  new BoxShadow(
                                    color: HexColor("#EDEBE6"),
                                    blurRadius: 2.0,
                                    offset: Offset(
                                      2.0, // Move to right 10  horizontally
                                      2.0, // Move to bottom 10 Vertically
                                    ),
                                  ),
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Icon(
                                        Icons.star,
                                        color: Colors.black,
                                        size: 15.0,
                                      )),
                                      Expanded(
                                          child: Text(
                                        _events[index].name,
                                        style: TextStyle(
                                            color: HexColor("#EDEBE6"),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      Expanded(
                                          child: Icon(
                                        Icons.location_on,
                                        color: Colors.black,
                                        size: 15.0,
                                      )),
                                      Expanded(
                                          child: Text(
                                            _events[index].place,
                                        style: TextStyle(
                                            color: HexColor("#EDEBE6"),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      Container(
                                        margin: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          color: HexColor("#EDEBE6"),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child:
                                        Image.file(File('Users/macbookpro/Desktop/ProjetFlutter/API/${_events[index].photo}')),

                                        height: 100,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          _events[index].dStart,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: HexColor("#EDEBE6"),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Learn more',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: HexColor("#EDEBE6"),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: GestureDetector(
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.black,
                                          size: 30.0,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EventDetails()),
                                          );
                                        },
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blueGrey,
            )
          ],
        ),
      ),
    );
  }
}

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
