import 'package:camp_with_us/Entity/following.dart';
import 'package:camp_with_us/widgets/event_description.dart';
import 'package:camp_with_us/widgets/event_detail_header.dart';
import 'package:camp_with_us/widgets/participant_scroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Entity/event.dart';

class EventDetailsPage extends StatelessWidget {
  EventDetailsPage(this.event);
  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            MovieDetailHeader(event),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Storyline(),
            ),

            SizedBox(height: 20.0),
            ActorScroller(),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
