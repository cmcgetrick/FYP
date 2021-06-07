import 'package:flutter/material.dart';
import 'package:flutter3/views/signin.dart';
import 'package:flutter3/views/signup.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool signedIn = true;

  void changeView() {
    setState(() {
      signedIn = !signedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (signedIn) {
      return SignIn(changeView: changeView);
    } else {
      return SignUp(changeView: changeView);
    }
  }
}
