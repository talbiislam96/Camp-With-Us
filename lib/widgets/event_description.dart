import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Storyline extends StatefulWidget {
  Storyline();

  @override
  _StorylineState createState() => _StorylineState();
}

class _StorylineState extends State<Storyline> {
  int eventId;
  String nameEvent,
      locationEvent,
      descriptionEvent,
      dStartEvent,
      dEndEvent,
      phoneEvent,
      categoryEvent;


  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int eventId = preferences.getInt("idEvent");
  }

  getEventInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    eventId = preferences.getInt("idEvent");
    final response =
        // await http.get("http://10.0.2.2:1337/event/show/$idConnectedUser");
        await http.get("http://localhost:1337/event/show/$eventId");
    final data = jsonDecode(response.body);
    setState(() {
      locationEvent = data['lieux_evenement'];
      nameEvent = data['nom_evenement'];
      descriptionEvent = data['description_evenement'];
      dStartEvent = data['date_debut_evenement'];
      dEndEvent = data['date_fin_evenement'];
      phoneEvent = data['infoline'];
      categoryEvent = data['type_evenement'];
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    getEventInfo();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Text(
              nameEvent.toString(),
              style: TextStyle(fontSize: 30),
            ),
          ),

          //SizedBox(height: 5.0),
          // RatingInformation(event),
          SizedBox(height: 12.0),

          SizedBox(height: 5.0),


          Text(
            'Category: $categoryEvent',
            style: textTheme.body1.copyWith(
              color: Colors.black45,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Starting Date: $dStartEvent',
            style: textTheme.body1.copyWith(
              color: Colors.black45,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Ending Date: $dEndEvent',
            style: textTheme.body1.copyWith(
              color: Colors.black45,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.phone,
                color: Colors.green,
              ),
              SizedBox(width: 5.0),
              Text(phoneEvent.toString(),
              style: textTheme.body1.copyWith(
                color: Colors.black45,
                fontSize: 16.0,
              ),)
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.place,
                color: Colors.red,
              ),
              SizedBox(width: 5.0),
              Text(locationEvent.toString(),
              style: textTheme.body1.copyWith(
                color: Colors.black45,
                fontSize: 16.0,
              ),),
              SizedBox(width: 100.0),

              GestureDetector(
                onTap: () {},
                child: Text(
                  "See route >",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            'Description',
            style: textTheme.subhead.copyWith(fontSize: 18.0),
          ),
          SizedBox(height: 8.0),
          Text(
            descriptionEvent ?? "No description available",
            style: textTheme.body1.copyWith(
              color: Colors.black45,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
