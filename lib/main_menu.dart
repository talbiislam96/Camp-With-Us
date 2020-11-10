import 'package:camp_with_us/WeatherAPI/screensWeather/loading_screen.dart';
import 'package:camp_with_us/WeatherAPI/screensWeather/location_screen.dart';
import 'package:camp_with_us/screens/about.dart';
import 'package:camp_with_us/screens/add_event.dart';
import 'package:camp_with_us/screens/event_details.dart';
import 'package:camp_with_us/screens/myevents.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camp_with_us/screens/profile.dart';
import 'package:camp_with_us/screens/events.dart';
import 'package:camp_with_us/screens/login.dart';




class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  PageController _pageController;
  int _page = 0;
  List icons = [
    Icons.home,
    Icons.add,
    Icons.person,
    Icons.event,
    Icons.wb_cloudy,
    Icons.info
   // Icons.ac_unit,
  ];
  List<Widget> _widgetOptions = <Widget>[
    Events(),
    AddEventPage(),
    ProfilePage(),
    Myevents(),
    LoadingScreen(),
    About()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              signOut();
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: <Widget>[
            SizedBox(width: 5),
            buildTabIcon(0),
            buildTabIcon(1),
            buildTabIcon(2),
            buildTabIcon(3),
            buildTabIcon(4),
            buildTabIcon(5),
            SizedBox(width: 5),
          ],
        ),
        color: Theme.of(context).primaryColor,
        //shape: CircularNotchedRectangle(),
      ),
     // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  String email = "", name = "", surname = "";
  int id = 0;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getInt("id");
      email = preferences.getString("email");
      name = preferences.getString("prenom");
      surname = preferences.getString("name");
    });
    print(id);
    print("user" + email);
    print("prenom" + name);
    print("name" + surname);
  }

  signOut() {
    setState(() {
      widget.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
      print("signed out");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  buildTabIcon(int index) {
    if (index == 2) {
      return IconButton(
        icon: Icon(
          icons[index],
          size: 24.0,
          color: Colors.transparent,
        ),
        onPressed: null,
      );
    } else {
      return IconButton(
        icon: Icon(
          icons[index],
          size: 24.0,
        ),
        color: _page == index
            ? Theme.of(context).accentColor
            : Theme.of(context).textTheme.caption.color,
        onPressed: () => _pageController.jumpToPage(index),
      );
    }
  }
}
