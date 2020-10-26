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

class Events extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Events> {
  List<Event> _events = List<Event>();
  String imageEvent;
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

    Locale myLocale = Localizations.localeOf(context);
    String localeDateFormatter = getLocaleDateFormatter(myLocale);
    initializeDateFormatting(localeDateFormatter);


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20.0),
            buildCategoryRow('Trending Events', context),
            SizedBox(height: 10.0),
            buildEventsList(context,_events),
            SizedBox(height: 10.0),
            buildCategoryRow('Category', context),
            SizedBox(height: 10.0),
            buildCategoryList(context),
            SizedBox(height: 20.0),
            buildCategoryRow('Followers', context),
            SizedBox(height: 10.0),
            buildFriendsList(),
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}

buildCategoryRow(String category, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        "$category",
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w800,
        ),
      ),
      FlatButton(
        child: Text(
          "See all",
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return Trending();
              },
            ),
          );
        },
      ),
    ],
  );
}

buildSearchBar(BuildContext context) {
  return PreferredSize(
    child: Padding(
      padding: EdgeInsets.only(
        top: Platform.isAndroid ? 30.0 : 50.0,
        left: 10.0,
        right: 10.0,
      ),
      child: SearchCard(),
    ),
    preferredSize: Size(
      MediaQuery.of(context).size.width,
      60.0,
    ),
  );
}

buildCategoryList(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height / 6,
    child: ListView.builder(
      primary: false,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: categories == null ? 0 : categories.length,
      itemBuilder: (BuildContext context, int index) {
        Map cat = categories[index];

        return CategoryItem(
          cat: cat,
        );
      },
    ),
  );
}

buildEventsList(BuildContext context,List<Event> events) {
  return Container(
    height: MediaQuery.of(context).size.height / 2.4,
    width: MediaQuery.of(context).size.width,
    child: ListView.builder(
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: events == null ? 0 : events.length,
      itemBuilder: (BuildContext context, int index) {

        return Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: SlideItem(
            img: events[index].photo,
            title: events[index].name,
            address: events[index].place,
            //rating: events["rating"],
            date: events[index].dStart,
          ),
        );
      },
    ),
  );
}

buildFriendsList() {
  return Container(
    height: 50.0,
    child: ListView.builder(
      primary: false,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: friends == null ? 0 : friends.length,
      itemBuilder: (BuildContext context, int index) {
        String img = friends[index];

        return Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: CircleAvatar(
            backgroundImage: AssetImage(
              img,
            ),
            radius: 25.0,
          ),
        );
      },
    ),
  );
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
