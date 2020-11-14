import 'package:camp_with_us/main_menu.dart';
import 'package:camp_with_us/screens/loginPage.dart';
import 'package:camp_with_us/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}
enum LoginStatus { notSignIn, signIn }


class _WelcomePageState extends State<WelcomePage> {
  final LocalAuthentication localAuth = LocalAuthentication();
  LoginStatus _loginStatus = LoginStatus.notSignIn;

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xff44bcd8).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Color(0xff1979a9)),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'Register now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
  signOut() async {
    setState(() {
      _loginStatus = LoginStatus.notSignIn;
    });
  }
  Widget _label() {
    return GestureDetector(
      onTap: ()async {
    bool weCanCheckBiometrics = await localAuth.canCheckBiometrics;

    if (weCanCheckBiometrics) {
    bool authenticated = await localAuth.authenticateWithBiometrics(
    localizedReason: "Authenticate to see camping events",
    );

    if (authenticated) {
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(
    builder: (context) => MainMenu(signOut),
    ),
    );
    }
    }
    },
      child: Container(
          margin: EdgeInsets.only(top: 40, bottom: 20),
          child: Column(
            children: <Widget>[
              Text(
                'Quick login with Touch ID',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              SizedBox(
                height: 20,
              ),
              Icon(Icons.fingerprint, size: 90, color: Colors.white),
              SizedBox(
                height: 20,
              ),
              Text(
                'Touch ID',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          )),
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
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: 'amp ',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'With ',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            TextSpan(
              text: 'Us',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
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
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff44bcd8), Color(0xff1979a9)])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 70,
              ),
              _title(),
              SizedBox(
                height: 40,
              ),
              _submitButton(),
              SizedBox(
                height: 20,
              ),
              _signUpButton(),
              SizedBox(
                height: 20,
              ),
              _label()
            ],
          ),
        ),
      ),
    );
  }
}
