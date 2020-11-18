import 'package:camp_with_us/Entity/event.dart';
import 'package:camp_with_us/Entity/participant.dart';
import 'package:camp_with_us/screens/PdfPreviewScreen.dart';
import 'package:camp_with_us/screens/event_details.dart';
import 'package:flutter/material.dart';
import 'package:camp_with_us/util/const.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:pdf/widgets.dart' as pw;

const kTextStyle = pw.TextStyle(
  fontSize: 20,
);
class MyeventsItem extends StatefulWidget {
  final int id;
  final String img;
  final String title;
  final String address;
  final double rating;
  final String date;

  MyeventsItem({
    Key key,
    @required this.id,
    @required this.img,
    @required this.title,
    @required this.address,
    @required this.rating,
    @required this.date,
  }) : super(key: key);

  @override
  _MyeventsItemState createState() => _MyeventsItemState();
}

class _MyeventsItemState extends State<MyeventsItem> {
  List<Event> _events = List<Event>();
  int idConnectedUser;


  final pdf = pw.Document();
  List<Participant> _participants = List<Participant>();
  String imageParticipant;
  int idEvent;
  int idProfile;
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

  Future<List<Participant>> fetchParticipants() async {
    var response = await http.get(
        Uri.encodeFull("http://localhost:1337/event/participants/${widget.id}"),
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

  writeOnPdf() {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Center(
            child: pw.Text(widget.title,
                style: pw.TextStyle(
                  fontSize: 50,
                  color: PdfColor.fromHex("0000ff"),
                )),
          ),
          pw.SizedBox(height: 40),
          pw.Text("Address: ${widget.address}",
              style: kTextStyle),
          pw.Text("Date: ${widget.date}",
          style: kTextStyle),
          pw.ListView.builder(
              itemBuilder: (pw.Context ctx, int index) {
                String name = _participants[index].name;
                String surname = _participants[index].surname;
                String phone = _participants[index].phone;
                print("name iis************************");

                print(name);

                return pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(name, style: kTextStyle),
                    pw.Text(surname, style: kTextStyle),
                    pw.Text(phone, style: kTextStyle),
                  ],
                );
              },
              itemCount: _participants.length)
        ];
      },
    ));
  }

  Future savePdf(String title) async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/$title.pdf");

    file.writeAsBytesSync(pdf.save());
  }

  Future<void> savePref(int id) async {
    print("event clicked");
    print(id);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("idEvent", id);
    preferences.commit();
  }

  Future<List<Event>> fetchMyEvents() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idConnectedUser = preferences.getInt("id");
    var response = await http
        .get(Uri.encodeFull("http://localhost:1337/myevents/$idConnectedUser"),
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

  Future<void> deleteEvent() async {
    String urlDelete = "http://localhost:1337/evenement/delete/${widget.id}";
    http.Request rq = http.Request('DELETE', Uri.parse(urlDelete));
    await http.Client().send(rq).then((response) {
      response.stream.bytesToString().then((value) {
        print("deleted");
      });
      fetchMyEvents().then((value) {
        setState(() {
          _events.addAll(value);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 2.5,
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () {
            savePref(widget.id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return EventDetailsPage(widget.id);
                },
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 3.0,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 3.5,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.file(
                          File('Users/macbookpro/Desktop/ProjetFlutter/API/${widget.img}' ??
                              'Users/macbookpro/Desktop/Camp-With-Us/assets/logo.png'),
                          fit: BoxFit.cover,
                        ),
                        //child: Image.asset('assets/backgroundProfile.jpg',
                        // fit: BoxFit.cover,

                        // ),
                      ),
                    ),
                    Positioned(
                      top: 6.0,
                      right: 6.0,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Constants.ratingBG,
                                size: 10.0,
                              ),
                              Text(
                                " ${widget.rating} ",
                                style: TextStyle(
                                  fontSize: 10.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 6.0,
                      right: 6.0,
                      child: Row(
                        children: <Widget>[
                          ButtonTheme(
                            child: RaisedButton(
                              child: Row(
                                children: [
                                  Icon(Icons.delete_forever),
                                  Text("Delete"),
                                ],
                              ),
                              textColor: Colors.white,
                              color: Colors.red,
                              onPressed: () {
                                setState(() {
                                  deleteEvent();
                                });
                              },
                              shape: StadiumBorder(),
                            ),
                          ),
                          ButtonTheme(
                            child: RaisedButton(
                              child: Row(
                                children: [
                                  Icon(Icons.picture_as_pdf),
                                  Text("See participants"),
                                ],
                              ),
                              textColor: Colors.white,
                              color: Colors.blue,
                              onPressed: () async {
                                setState(() {
                                  writeOnPdf();

                                });
                                await savePdf(widget.title);
                                Directory documentDirectory =
                                    await getApplicationDocumentsDirectory();

                                String documentPath = documentDirectory.path;

                                String fullPath =
                                    "$documentPath/${widget.title}.pdf";

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PdfPreviewScreen(
                                              path: fullPath,
                                            )));
                              },
                              shape: StadiumBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7.0),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "${widget.title}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 7.0),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Icon(
                            Icons.place,
                            color: Colors.red,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "${widget.address}",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Icon(
                            Icons.calendar_today,
                            color: Colors.blueAccent,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "${widget.date}",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
