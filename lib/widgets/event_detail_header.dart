import 'dart:io';

import 'package:camp_with_us/screens/event_creator_profile.dart';
import 'package:flutter/cupertino.dart';
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
  String nameEvent,
      categoryEvent,
      phoneEvent,
      imageEvent,
      locationEvent,
      nomUser,
      prenomUser,
      imageUser,
      imageUserProfile;
  File _image;
String buttonText = "Participate";
Icon buttonIcon ;
Color buttonColor;

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

  getEventUserCreator() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    eventId = preferences.getInt("idEvent");
    final response =
        // await http.get("http://10.0.2.2:1337/profile/event/$idConnectedUser");
        await http.get("http://localhost:1337/profile/event/$eventId");

    setState(() {
      final data = jsonDecode(response.body);
      nomUser = data['name'];
      prenomUser = data['prenom'];
      imageUser = data['image_user'];
      _image = File("Users/macbookpro/Desktop/ProjetFlutter/API/$imageUser");
      //_image = File("C:/Users/islam/Desktop/camp_with_us/$imageProfile");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
    getEventInfo();
    getEventUserCreator();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        ArcBannerImage(),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 150),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: FileImage(_image ??
                              File(
                                  "Users/macbookpro/Desktop/ProjetFlutter/Camp-With-Us/assets/user_profile.png")),
                          radius: 40.0,
                        ),
                        Text(
                          '$prenomUser $nomUser' ?? "User Not Found",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ],
                    ),

                    ButtonTheme(
                      minWidth: 50.0,
                      height: 40.0,
                      child: RaisedButton(
                        child: Row(
                          children: [
                            buttonIcon ?? Icon(Icons.check_circle),
                             Text(buttonText),
                          ],
                        ),
                        textColor: Colors.white,
                        color: buttonColor ?? Colors.green,
                        onPressed: () {
                          setState(() {
                            if (buttonText == "Participate" ){
                              buttonText = "Cancel";
                              buttonIcon = Icon(Icons.cancel);
                              buttonColor = Colors.red;
                            }
                            else if (buttonText == "Cancel"){
                              buttonIcon = Icon(Icons.check_circle);
                              buttonText = "Participate";
                              buttonColor = Colors.green;

                            }
                          });

                        },
                        shape: StadiumBorder(),
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
            ),

          ],

        ),
      ],
    );
  }
}
