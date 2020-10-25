
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:camp_with_us/locale_time_toolkit.dart';

class Events extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Events> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#819EA6"),
      body: Container(
      decoration: BoxDecoration(
      color: HexColor("#EDEBE6"),
    borderRadius: BorderRadius.only(
    topRight: Radius.circular(20),
    topLeft: Radius.circular(20)),

      ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: ListView.builder(
                        padding: EdgeInsets.only(top: 0),
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return EventTile();
                        }),
                  ),
                ],
              ),
            )





          ],

        ),

        ),
      );

  }
}

class EventTile extends StatefulWidget {
  @override
  _EventTileState createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    String localeDateFormatter = getLocaleDateFormatter(myLocale);
    initializeDateFormatting(localeDateFormatter);

    return Container(
      margin: EdgeInsets.only(
        top: 10,
        left: 4,
        right: 4,
      ),
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
          color: HexColor("#819EA6"),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            new BoxShadow(
              color: HexColor("#EDEBE6"),
              blurRadius: 2.0,
              offset: Offset(
                2.0, // Move to right 10  horizontally
                2.0, // Move to bottom 10 Vertically
              ),
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Icon(
                      Icons.star,
                      color: Colors.black,
                      size: 15.0,
                    )

                ),


                Expanded(
                    child: Text(
                  'Event Name ',
                  style: TextStyle(
                      color: HexColor("#EDEBE6"),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),

                Expanded(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.black,
                      size: 15.0,
                    )

                ),
                Expanded(
                    child: Text(
                      'Location ',
                      style: TextStyle(
                          color: HexColor("#EDEBE6"),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),


                Container(
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: HexColor("#EDEBE6"),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset("assets/logo.png"),
                  height: 100,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    DateFormat.yMd(localeDateFormatter)
                        .format(new DateTime.now()),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: HexColor("#EDEBE6"),
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Learn more',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: HexColor("#EDEBE6"),
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                      size: 30.0,
                    )

                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
