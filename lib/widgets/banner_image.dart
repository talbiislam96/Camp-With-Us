import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ArcBannerImage extends StatefulWidget {

  ArcBannerImage();

  @override
  _ArcBannerImageState createState() => _ArcBannerImageState();
}

class _ArcBannerImageState extends State<ArcBannerImage> {
  int eventId;
  String imageEvent;
  File _image;

  getEventInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    eventId = preferences.getInt("idEvent");
    final response =
        // await http.get("http://10.0.2.2:1337/user/show/$idConnectedUser");
        await http.get("http://localhost:1337/event/show/$eventId");
    setState(() {
      final data = jsonDecode(response.body);
      imageEvent = data['photo_evenement'];
      _image = File("Users/macbookpro/Desktop/ProjetFlutter/API/$imageEvent");
      //_image = File("C:/Users/islam/Desktop/camp_with_us/$imageProfile");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEventInfo();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return ClipPath(
      clipper: ArcClipper(),
      child: Column(
        children: [
          Image.file(
            _image ??
                File(
                    "Users/macbookpro/Desktop/ProjetFlutter/Camp-With-Us/assets/bg2.jpeg"),
            width: screenWidth,
            height: 230.0,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
