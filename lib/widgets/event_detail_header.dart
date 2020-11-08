import 'dart:io';

import 'package:camp_with_us/Entity/event.dart';
import 'package:camp_with_us/screens/event_creator_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  int idConnectedUser;
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
  Icon buttonIcon;
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

  participate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idConnectedUser = preferences.getInt("id");
    eventId = preferences.getInt("idEvent");
    final responseParticipate =
        await http.post("http://localhost:1337/participant/add", body: {
      "id_user": idConnectedUser.toString(),
      "id_evenement": eventId.toString(),
    });
    successToast("Thank you for participating !");
  }

  incrementPlacesEvent() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    eventId = preferences.getInt("idEvent");
    final response = await http
        //.put("http://10.0.2.2:1337/user/edit/$idConnectedUser", body: {
        .put("http://localhost:1337/annuler/$eventId");
  }

  decrementPlacesEvent() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    eventId = preferences.getInt("idEvent");
    final response = await http
        //.put("http://10.0.2.2:1337/user/edit/$idConnectedUser", body: {
        .put("http://localhost:1337/participate/$eventId");
    final data = jsonDecode(response.body);
    if (data == 'no more places') {
      buttonIcon = Icon(Icons.check_circle);
      buttonText = "No More Places";
      buttonColor = Colors.green;
      failToast("No More Places");
    }
  }

  onButtonClick() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    eventId = preferences.getInt("idEvent");
    idConnectedUser = preferences.getInt("id");
    String urlParticipate = "http://localhost:1337/participant/add";
    String urlCancel = "http://localhost:1337/participant/delete";
    String urlIncrement = "http://localhost:1337/annuler/$eventId";
    String urlDecrement = "http://localhost:1337/participate/$eventId";
    String urlVerify = "http://localhost:1337/participant/verify";

    if (buttonText == "Participate") {
      final responseDecrement = await http.put(urlDecrement);
      final dataDecrement = jsonDecode(responseDecrement.body);
      final responseVerify = await http.post(urlVerify, body: {
        "id_user": idConnectedUser.toString(),
        "id_evenement": eventId.toString(),
      });

      final dataVerify = jsonDecode(responseVerify.body);

      if (dataDecrement == 'no more places') {
        failToast("No More Places");
        print('no more places');
      }
      /*else if (dataVerify == 'participated already') {
        failToast("Already participated");
        print('Already participated');
        buttonText = "Cancel";
        buttonIcon = Icon(Icons.cancel);
        buttonColor = Colors.red;
      } */
      else if (dataVerify == 'vous pouvez participer') {
        final responseParticipate = await http.post(urlParticipate, body: {
          "id_user": idConnectedUser.toString(),
          "id_evenement": eventId.toString(),
        });
        print('participated');
        final responseDecrement = await http.put(urlDecrement);
        print('decremented');

        setState(() {
          buttonText = "Cancel";
          buttonIcon = Icon(Icons.cancel);
          buttonColor = Colors.red;
        });

      }
    } else if (buttonText == "Cancel") {
      http.Request rq = http.Request('DELETE', Uri.parse(urlCancel));
      rq.bodyFields = {
        'id_user': idConnectedUser.toString(),
        'id_evenement': eventId.toString(),
      };
      await http.Client().send(rq).then((response) {
        response.stream.bytesToString().then((value) {
          //print(value); // it will print: {"status":"Success"}
          if (value == '"participation annule avec succes"') {
            setState(() {
              buttonIcon = Icon(Icons.check_circle);
              buttonText = "Participate";
              buttonColor = Colors.green;
            });

            print('participation annule avec succes');
          } else {
            print("error cancel participation");
          }
        });
      });

      final responseIncrement = await http.put(urlIncrement);
      if (responseIncrement.statusCode == 200) {
        print("incremented successfully");
      } else if (responseIncrement.statusCode != 200) {
        print("error increment");
      }
    }
  }

  void cancelParticipation() async {
    http.Request rq = http.Request(
        'DELETE', Uri.parse('http://localhost:1337/participant/delete'));
    rq.bodyFields = {
      'id_user': idConnectedUser.toString(),
      'id_evenement': eventId.toString(),
    };
    await http.Client().send(rq).then((response) {
      response.stream.bytesToString().then((value) {
        print(value); // it will print: {"status":"Success"}
      });
    });
  }

  verifyParticipation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idConnectedUser = preferences.getInt("id");
    eventId = preferences.getInt("idEvent");
    final response =
        await http.post("http://localhost:1337/participant/verify", body: {
      "id_user": idConnectedUser.toString(),
      "id_evenement": eventId.toString(),
    });

    final data = jsonDecode(response.body);
    if (data == 'participated already') {
      buttonText = "Cancel";
      buttonIcon = Icon(Icons.cancel);
      buttonColor = Colors.red;
    } else if (data == 'vous pouvez participer') {
      buttonIcon = Icon(Icons.check_circle);
      buttonText = "Participate";
      buttonColor = Colors.green;
    }
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

  successToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

  failToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  @override
  void initState() {
    super.initState();
    verifyParticipation();
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
                            onButtonClick();
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
