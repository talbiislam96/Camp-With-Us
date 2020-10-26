import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:camp_with_us/profile.dart';
import 'package:camp_with_us/events.dart';
import 'package:camp_with_us/login.dart';
import 'package:flutter/material.dart';
import 'package:camp_with_us/screens/home.dart';

import 'article.dart';

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
    Icons.label,
    Icons.add,
    Icons.notifications,
    Icons.person,
  ];
  List<Widget> _widgetOptions = <Widget>[
    Events(),
    Article(),
    Article(),
    ProfilePage()
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
            icon: Icon(Icons.lock_open),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 7),
            buildTabIcon(0),
            buildTabIcon(1),
            buildTabIcon(2),
            buildTabIcon(3),
            buildTabIcon(4),
            SizedBox(width: 7),
          ],
        ),
        color: Theme.of(context).primaryColor,
        shape: CircularNotchedRectangle(),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: Icon(
          Icons.add,
        ),
        onPressed: () => _pageController.jumpToPage(_page),
      ),
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
      Navigator.push(
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
/* int _selectedTabIndex = 0;

  List<Widget> _widgetOptions = <Widget>[ProfilePage(), Events(), Article()];

  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  signOut() {
    setState(() {
      widget.signOut();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
      print("signed out");
    });
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#EDEBE6"),
      appBar: AppBar(
        backgroundColor: HexColor("#819EA6"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              signOut();
            },
            icon: Icon(Icons.lock_open),
          )
        ],
      ),
      body: _widgetOptions[_selectedTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: _changeIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text("My Account")),
          BottomNavigationBarItem(
              icon: Icon(Icons.star), title: Text("Events")),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), title: Text("Items")),
        ],
        selectedItemColor: HexColor("#EDEBE6"),
        unselectedItemColor: Colors.black,
        backgroundColor: HexColor("#819EA6"),
      ),
    );
  }
*/
}
