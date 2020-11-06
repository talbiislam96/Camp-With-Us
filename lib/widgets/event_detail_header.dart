import 'package:camp_with_us/screens/event_creator_profile.dart';
import 'package:flutter/material.dart';
import 'banner_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';


class EventDetailHeader extends StatefulWidget {

  @override
  _EventDetailHeaderState createState() => _EventDetailHeaderState();
}

class _EventDetailHeaderState extends State<EventDetailHeader> {

  int eventId;
  String nameEvent, categoryEvent, phoneEvent, imageEvent, locationEvent;


  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int eventId = preferences.getInt("idEvent");
  }

  getEventInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    eventId = preferences.getInt("idEvent");
    final response =
        // await http.get("http://10.0.2.2:1337/user/show/$idConnectedUser");
        await http.get("http://localhost:1337/event/show/$eventId");
    final data = jsonDecode(response.body);
    setState(() {
      nameEvent = data['nom_evenement'];
      locationEvent = data['lieux_evenement'];
      categoryEvent = data['type_evenement'];
      phoneEvent = data['infoline'];

    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
    getEventInfo();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    var movieInformation = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          nameEvent.toString(),
          style: textTheme.title,
        ),
        SizedBox(height: 5.0),
        // RatingInformation(event),
        // SizedBox(height: 12.0),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 180.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Icon(
                        Icons.place,
                        color: Colors.red,
                      ),
                    ),
                    Text(locationEvent.toString()),
                  ],
                ),
              ),
            ),
          ],
        ),


        SizedBox(height: 5.0),

        GestureDetector(
          onTap: () {},
          child: Text(
            "See Place",
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
        ),

        ButtonTheme(
          minWidth: 50.0,
          height: 40.0,
          child: RaisedButton(
            child: new Text("Add Camping"),
            textColor: Colors.white,
            color: Colors.green,
            onPressed: () {},
            shape: StadiumBorder(),
          ),
        ),
      ],
    );

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 140.0),
          child: ArcBannerImage(),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 16.0,
          right: 16.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                child: Column(
                  children: [
                    CircleAvatar(
                      //backgroundImage: AssetImage(following.image),
                      backgroundImage: NetworkImage(
                          'https://img.freepik.com/free-psd/young-man-placing-his-hands-hips_1187-6830.jpg?size=338&ext=jpg'),
                      radius: 40.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      //child: Text(following.name),
                      child: Text(
                        'test',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreatorProfile()),
                  );
                },
              ),
              SizedBox(width: 16.0),
              Expanded(child: movieInformation),
            ],
          ),
        ),
      ],
    );
  }
}
