import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:camp_with_us/profile.dart';
import 'package:camp_with_us/events.dart';
import 'package:camp_with_us/article.dart';
import 'package:camp_with_us/login.dart';
class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }

}

class _HomeState extends State<Home>{

  int _selectedTabIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    MainMenu(() {}),
    ProfilePage(),
    Events(),
    Article()

  ];

  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text("codesundar"), backgroundColor: Colors.lightBlue[900]),
      body: Center(child: _widgetOptions[_selectedTabIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: _changeIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text("Search")),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text("My Account")),
        ],
      ),
    );







  }






}