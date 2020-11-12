import 'package:camp_with_us/Entity/following.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:camp_with_us/locale_time_toolkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:camp_with_us/screens/trending.dart';
import 'package:camp_with_us/util/categories.dart';
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
  List<Following> _followings = List<Following>();
  int idConnectedUser;
  String imageEvent;
  String imageFollowing;

  Future<List<Following>> fetchFollowings() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idConnectedUser = preferences.getInt("id");
    var response = await http.get(
        Uri.encodeFull("http://localhost:1337/follow/show/$idConnectedUser"),
       // Uri.encodeFull("http://10.0.2.2:1337/follow/show/$idConnectedUser"),
        headers: {"Accept": "application/json"});
    var followings = List<Following>();

    if (response.statusCode == 200) {
      var eventsJson = json.decode(response.body);
      print(eventsJson);
      for (var eventJson in eventsJson) {
        followings.add(Following.fromJson(eventJson));
      }
    }
    return followings;
  }

  Future<List<Event>> fetchEvents() async {
    var response =
        await http.get(Uri.encodeFull("http://localhost:1337/evenement/show"),
           // await http.get(Uri.encodeFull("http://10.0.2.2:1337/evenement/show"),
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
    fetchEvents().then((value) {
      setState(() {
        _events.addAll(value);
      });
    });
    fetchFollowings().then((value) {
      setState(() {
        _followings.addAll(value);
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
            buildEventsList(context, _events),
            SizedBox(height: 10.0),
            buildCategoryRow('Category', context),
            SizedBox(height: 10.0),
            buildCategoryList(context),
            SizedBox(height: 20.0),
            buildCategoryRowWithoutText('Following', context),
            SizedBox(height: 10.0),
            buildFriendsList(context, _followings),
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

buildCategoryRowWithoutText(String category, BuildContext context) {
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

buildEventsList(BuildContext context, List<Event> events) {
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
            id: events[index].id,
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

buildFriendsList(BuildContext context, List<Following> followings) {
  return Container(
    height: 50.0,
    child: ListView.builder(
      primary: false,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: followings == null ? 0 : followings.length,
      itemBuilder: (BuildContext context, int index) {
        File img = File(
            'Users/macbookpro/Desktop/ProjetFlutter/API/${followings[index].image}');

        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Column(
            children: [
              GestureDetector(
                child: CircleAvatar(
                  backgroundImage: FileImage(
                    img,
                  ),
                  radius: 25.0,
                ),
                onTap: () {
                  print("friend clicked");
                },
              ),
            ],
          ),
        );
      },
    ),
  );
}
