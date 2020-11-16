import 'package:camp_with_us/widgets/myevents_item.dart';
import 'package:flutter/material.dart';
import 'package:camp_with_us/Entity/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Myevents extends StatefulWidget {

  @override
  _MyeventsState createState() => _MyeventsState();
}

class _MyeventsState extends State<Myevents> {
  List<Event> _events = List<Event>();
  final List<Event> events;
  int idConnectedUser;

  _MyeventsState({Key key, @required this.events}) ;

  String imageEvent;
  //final Event event = ModalRoute.of(context).settings.arguments;

  Future<List<Event>> fetchEvents() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idConnectedUser = preferences.getInt("id");
    var response = await http.get(
        Uri.encodeFull("http://localhost:1337/myevents/$idConnectedUser"),
        //Uri.encodeFull("http://10.0.2.2:1337/evenement/show"),
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
    setState(() {
      fetchEvents().then((value){
        setState(() {
          _events.addAll(value);
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1979a9),
        elevation: 0.0,
        title: Text("My Events"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _events == null ? 0 : _events.length,
              itemBuilder: (BuildContext context, int index) {
                return MyeventsItem(
                  id: _events[index].id,
                  img: _events[index].photo,
                  title: _events[index].name,
                  address: _events[index].place,
                  rating: _events[index].rating.toDouble(),
                  date: _events[index].dStart,
                );

              },
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
