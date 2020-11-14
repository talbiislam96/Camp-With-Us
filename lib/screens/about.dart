import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.blue,
              child: Text(
                "About App:",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Flexible(
              child: Text(
                "Camp With Us an application which make you manage your camping events and keep you updated about latest campings.",
                maxLines: 4,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.blue,
                  child: Text(
                    "Developed By:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage("assets/img1.jpg"),
                          radius: 50.0,
                        ),
                        Text(
                          "yafet.shil@gmail.com",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/islam.png"),
                          radius: 50.0,
                        ),
                        Text(
                          "islam.talbi96@gmail.com",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
