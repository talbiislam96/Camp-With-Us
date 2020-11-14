import 'package:flutter/material.dart';
import 'package:camp_with_us/widgets/bezierContainer.dart';
import 'loginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';


class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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

  Future<void> save() async {
    //final response = await http.post("http://10.0.2.2:1337/register", body: {
    final response = await http.post("http://localhost:1337/register", body: {
      "prenom": name,
      "name": surname,
      "email": email,
      "tel_user": mobile,
      "password": password,
    });

    final data = jsonDecode(response.body);
    if (data == "You are successfully registered !") {
      setState(() {
        Navigator.pop(context);
      });
      registerToast(data);
    } else if (data == "Mail address already in use !'") {
      registerToast("Your email address is already registered !");
    } else {
      registerToast(data);
    }
  }

  registerToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Form(
        key: _key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            //card for Fullname TextFormField
            Card(
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
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: (){
        check();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff44bcd8), Color(0xff1979a9)])),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text(
                'Login',
                style: TextStyle(
                    color: Color(0xff44bcd8),
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'C',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xff1979a9),
          ),
          children: [
            TextSpan(
              text: 'amp ',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'With ',
              style: TextStyle(color: Color(0xff1979a9), fontSize: 30),
            ),
            TextSpan(
              text: 'Us',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username"),
        _entryField("Email id"),
        _entryField("Password", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .14),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
class JosKeys {
   final _key1 = new GlobalKey<FormState>();

   final _key2 = new GlobalKey<FormState>();
}
