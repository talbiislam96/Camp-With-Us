import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:camp_with_us/profile.dart';
import 'package:camp_with_us/events.dart';
import 'package:camp_with_us/article.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String email, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http.post("http://localhost:1337/login", body: {
      "email": email,
      "password": password,
    });

    final data = jsonDecode(response.body);

    if (data == "Check your password please !") {
      loginToast("Check your password please !");
    } else if (data == "This email address is not registered !") {
      loginToast("Check your email address please !");
    } else {
      String emailAPI = data['email'];
      String nameAPI = data['prenom'];
      String surnameAPI = data['name'];
      int id = data['id'];
      print("email:" + emailAPI);
      print(data);
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(emailAPI, nameAPI, surnameAPI, id);
      });
      print("successfully logged in");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainMenu(signOut)),
      );
    }
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  savePref(String email, String name, String surname, int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("prenom", name);
      preferences.setString("name", surname);
      preferences.setString("email", email);
      preferences.setInt("id", id);
      preferences.commit();
    });
  }

  var value;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("id");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("prenom", null);
      preferences.setString("name", null);
      preferences.setString("email", null);
      preferences.setString("id", null);
      print("empty sharedPref");
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    //switch (_loginStatus) {
    //  case LoginStatus.notSignIn:
    return Scaffold(
      backgroundColor: HexColor("#819EA6"),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
//            color: Colors.grey.withAlpha(20),
                color: HexColor("#819EA6"),
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Container(
                          width: 200.0,
                          height: 200.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              image: DecorationImage(
                                  image: AssetImage(
                                    "assets/logo.png",
                                  ),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 50,
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: HexColor("#EDEBE6"), fontSize: 30.0),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),

                      //card for Email TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please Insert Email";
                            }
                          },
                          onSaved: (e) => email = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: Colors.black),
                              ),
                              //contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                              labelText: "Email"),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),

                      // Card for password TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Password Can't be Empty";
                            }
                          },
                          obscureText: _secureText,
                          onSaved: (e) => password = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child: Icon(Icons.phonelink_lock,
                                  color: Colors.black),
                            ),
                            suffixIcon: IconButton(
                              onPressed: showHide,
                              icon: Icon(_secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 12,
                      ),

                      FlatButton(
                        onPressed: null,
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: HexColor("#EDEBE6"),
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(14.0),
                      ),

                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: 44.0,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Text(
                                  "Login",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                textColor: Colors.black,
                                color: HexColor("#EDEBE6"),
                                onPressed: () {
                                  check();
                                }),
                          ),
                          SizedBox(
                            height: 44.0,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                textColor: Colors.black,
                                color: HexColor("#EDEBE6"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Register()),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // break;

    //  case LoginStatus.signIn:
    return MainMenu(signOut);
//        return ProfilePage(signOut);
    //  break;
  }
  // }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String name, surname, email, mobile, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }

  save() async {
    final response = await http.post("http://localhost:1337/register", body: {
      "prenom": name,
      "name": surname,
      "email": email,
      "tel_user": mobile,
      "password": password,
    });

    final data = jsonDecode(response.body);
    print(data);
    // int value = data['value'];
    //String message = data['message'];
    if (data == "You are successfully registered !") {
      setState(() {
        Navigator.pop(context);
      });
      print(data);
      registerToast(data);
    } else if (data == "Mail address already in use !'") {
      print(data);
      registerToast("Your email address is already registered !");
    } else {
      print(data);
      registerToast(data);
    }
  }

  registerToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#819EA6"),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: HexColor("#819EA6"),
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Container(
                          width: 200.0,
                          height: 175.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              image: DecorationImage(
                                  image: AssetImage(
                                    "assets/logo.png",
                                  ),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 40,
                        child: Text(
                          "Register",
                          style: TextStyle(
                              color: HexColor("#EDEBE6"), fontSize: 30.0),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),

                      //card for Fullname TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert your Name";
                            }
                          },
                          onSaved: (e) => name = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Name"),
                        ),
                      ),
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert your Surname";
                            }
                          },
                          onSaved: (e) => surname = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Surname"),
                        ),
                      ),

                      //card for Email TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Email";
                            }
                          },
                          onSaved: (e) => email = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child: Icon(Icons.email, color: Colors.black),
                            ),
                            contentPadding: EdgeInsets.all(18),
                            labelText: "Email",
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),

                      //card for Mobile TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Mobile Number";
                            }
                          },
                          onSaved: (e) => mobile = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child: Icon(Icons.phone, color: Colors.black),
                            ),
                            contentPadding: EdgeInsets.all(18),
                            labelText: "Mobile",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),

                      //card for Password TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          obscureText: _secureText,
                          onSaved: (e) => password = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: showHide,
                                icon: Icon(_secureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.phonelink_lock,
                                    color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Password"),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(12.0),
                      ),

                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: 44.0,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Text(
                                  "Register",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                textColor: Colors.black,
                                color: HexColor("#EDEBE6"),
                                onPressed: () {
                                  check();
                                }),
                          ),
                          SizedBox(
                            height: 44.0,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Text(
                                  " Login",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                textColor: Colors.black,
                                color: HexColor("#EDEBE6"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;

  MainMenu(this.signOut);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _selectedTabIndex = 0;

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

  //  Action on Bottom Bar Press

}
