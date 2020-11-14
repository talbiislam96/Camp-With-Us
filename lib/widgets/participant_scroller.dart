import 'dart:io';

import 'package:camp_with_us/Entity/following.dart';
import 'package:camp_with_us/Entity/participant.dart';
import 'package:camp_with_us/screens/event_creator_profile.dart';
import 'package:flutter/material.dart';
import '../Entity/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ActorScroller extends StatefulWidget {

  ActorScroller();

  @override
  _ActorScrollerState createState() => _ActorScrollerState();
}

class _ActorScrollerState extends State<ActorScroller> {
  List<Participant> _participants = List<Participant>();
  String imageParticipant;
  int idEvent;
  int idProfile;

  Future<void> savePref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("idProfile", idProfile);
    int id = preferences.getInt("idProfile");
    print('id profile pressed: $id');
  }


  Future<List<Participant>> fetchParticipants() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idEvent = preferences.getInt("idEvent");


    var response = await http.get(
        Uri.encodeFull("http://localhost:1337/event/participants/$idEvent"),
        //Uri.encodeFull("http://10.0.2.2:1337/evenement/show"),
        headers: {"Accept": "application/json"});
    var participants = List<Participant>();

    if (response.statusCode == 200) {
      var participantsJson = json.decode(response.body);
      print(participantsJson);
      for (var eventJson in participantsJson) {
        participants.add(Participant.fromJson(eventJson));
      }
    }
    return participants;
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchParticipants().then((value) {
      setState(() {
        _participants.addAll(value);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return buildParticipantsList(context,_participants);

  }
  buildParticipantsList(BuildContext context, List<Participant> participants)  {
    var textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Participants',
            style: textTheme.subhead.copyWith(fontSize: 18.0),
          ),
        ),
        SizedBox.fromSize(
          size: const Size.fromHeight(120.0),
          child: ListView.builder(
            itemCount: participants == null ? 0 : participants.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 12.0, left: 20.0),
            itemBuilder: (BuildContext ctx, int index)  {
              File img = File(
                  'Users/macbookpro/Desktop/ProjetFlutter/API/${participants[index].image}');
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        idProfile = participants[index].idUser;
                        savePref();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreatorProfile()),
                        );
                      },
                      child: CircleAvatar(
                        //backgroundImage: AssetImage(following.image),
                        backgroundImage: FileImage(
                          img,
                        ),
                        radius: 40.0,
                      ),
                    ),

                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }


}
