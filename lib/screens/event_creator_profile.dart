import 'package:camp_with_us/Entity/event.dart';
import 'package:camp_with_us/widgets/slide_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class CreatorProfile extends StatefulWidget {
  _CreatorProfileState createState() => _CreatorProfileState();
}

class _CreatorProfileState extends State<CreatorProfile> {
  String emailProfile, nameProfile, surnameProfile, mobileProfile, imageProfile, nbrFollowers;
  int profileId;
  File _image;
  List<Event> _events = List<Event>();
  final List<Event> events;
  _CreatorProfileState({Key key, @required this.events}) ;

  int idProfile;
  Future<List<Event>> fetchEvents() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idProfile = preferences.getInt("idProfile");
    var response = await http.get(
        Uri.encodeFull("http://localhost:1337/myevents/$idProfile"),
        //Uri.encodeFull("http://10.0.2.2:1337/evenement/show"),
        headers: {"Accept": "application/json"});
    var events = List<Event>();

    if (response.statusCode == 200) {
      var eventsJson = json.decode(response.body);
      print("events profile: $eventsJson");
      for (var eventJson in eventsJson) {
        events.add(Event.fromJson(eventJson));
      }
    }
    return events;
  }
  Future<void> getNumberFollowers() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    profileId = preferences.getInt("idProfile");
    final response =
    // await http.get("http://10.0.2.2:1337/user/show/$idConnectedUser");
    await http.get("http://localhost:1337/follower/show/$profileId");
    final data = jsonDecode(response.body);
     nbrFollowers = data['numberFollowers'].toString();
    print(data);
    print(nbrFollowers);
  }

  getProfileInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    profileId = preferences.getInt("idProfile");
    print("profile id:" + profileId.toString());
    final response =
    // await http.get("http://10.0.2.2:1337/user/show/$idConnectedUser");
    await http.get("http://localhost:1337/user/show/$profileId");

    final data = jsonDecode(response.body);

    emailProfile = data['email'];
    nameProfile = data['prenom'];
    surnameProfile = data['name'];
    mobileProfile = data['tel_user'];
    imageProfile = data['image_user'];

    setState(() {
      //_image = File("Users/macbookpro/Desktop/ProjetFlutter/API/$imageProfile");
      if (imageProfile == null) {
        _image = File(
            "Users/macbookpro/Desktop/ProjetFlutter/Camp-With-Us/assets/user_profile.png");
      } else {
        _image = File("Users/macbookpro/Desktop/ProjetFlutter/API/$imageProfile");
        //_image = File("C:/Users/islam/Desktop/camp_with_us/$imageProfile");
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileInfo();
    getNumberFollowers();
    fetchEvents().then((value){
      setState(() {
        _events.addAll(value);
      });
    });
  }
  Widget build(BuildContext cx) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: new ListView(
        children: <Widget>[
          new Column(
            children: <Widget>[
              Container(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 200.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/bg1.jpeg'))),
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      top: 100.0,
                      child: Container(
                        height: 150.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(_image ?? File(
                                  "Users/macbookpro/Desktop/ProjetFlutter/Camp-With-Us/assets/user_profile.png") ) ,
                            ),
                            border:
                                Border.all(color: Colors.white, width: 6.0)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                height: 100.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '$nameProfile $surnameProfile',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 28.0),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Icon(
                      Icons.check_circle,
                      color: Colors.blueAccent,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.phone,
                        color: Colors.green,),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '$mobileProfile',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.mail,
                        color: Colors.blue,),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '$emailProfile',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.list),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Followed by',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '$nbrFollowers peoples',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {},
                          child:Text('Follow', style: TextStyle(fontSize: 20,color: Colors.white)),
                          color: Colors.blue,

                        ),
                      ),
                    ]),
                    Container(
                      height: 10.0,
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Events',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w800,
                          ),
                        )),
                    Container(
                      height: MediaQuery.of(context).size.height / 2.4,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _events == null ? 0 : _events.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: SlideItem(
                              id: _events[index].id,
                              img: _events[index].photo,
                              title: _events[index].name,
                              address: _events[index].place,
                              //rating: events["rating"],
                              date: _events[index].dStart,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _showMoreOption(cx) {
    showModalBottomSheet(
      context: cx,
      builder: (BuildContext bcx) {
        return new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.feedback,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Give feedback or report this profile',
                    style: TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.block,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Block',
                    style: TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.link,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Copy link to profile',
                    style: TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Search Profile',
                    style: TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
