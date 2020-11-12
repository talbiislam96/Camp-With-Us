import 'package:camp_with_us/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:camp_with_us/util/const.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';



void main() => runApp(new MaterialApp(
  debugShowCheckedModeBanner: false,
  title: Constants.appName,
  /*theme: Constants.darkTheme,
  darkTheme: Constants.darkTheme,*/
  home: Login(),
));

