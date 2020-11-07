import 'package:camp_with_us/widgets/event_description.dart';
import 'package:camp_with_us/widgets/event_detail_header.dart';
import 'package:camp_with_us/widgets/participant_scroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventDetailsPage extends StatefulWidget {
  EventDetailsPage(this.id);
  final int id;

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            EventDetailHeader(),

              Storyline(),


            SizedBox(height: 20.0),
            ActorScroller(),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
