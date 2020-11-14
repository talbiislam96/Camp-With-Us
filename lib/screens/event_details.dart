import 'package:camp_with_us/screens/about.dart';
import 'package:camp_with_us/screens/add_event.dart';
import 'package:camp_with_us/screens/events.dart';
import 'package:camp_with_us/screens/myevents.dart';
import 'package:camp_with_us/screens/profile.dart';
import 'package:camp_with_us/widgets/event_description.dart';
import 'package:camp_with_us/widgets/event_detail_header.dart';
import 'package:camp_with_us/widgets/participant_scroller.dart';
import 'package:camp_with_us/widgets/rating_imformation.dart';
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

      appBar: AppBar(
        title: Text('Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            EventDetailHeader(),
            Storyline(),
           // RatingInformation(),
            SizedBox(height: 20.0),
            ActorScroller(),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
