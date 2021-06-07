import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter3/usage/constants.dart';
import 'package:flutter3/services/auth.dart';
import 'package:flutter3/services/database.dart';
import 'package:flutter3/views/categories.dart';
import 'package:flutter3/widget/widget.dart';

class SignIn extends StatefulWidget {
  final Function changeView;

  SignIn({this.changeView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthService authService = new AuthService();
  DatabaseService databaseService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  String email = '', password = '';

  getandSignIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });

      await authService.signIn(email, password).then((value) {
        Constants.saveUserLoggedInSharedPreference(true);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Categories()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: LogoWidget(),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: _loading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                children: [
                  Spacer(),
                  Form(
                    key: _formKey,
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            validator: (val) => validateEmail(email)
                                ? null
                                : "Enter correct email",
                            decoration: InputDecoration(hintText: "Email"),
                            onChanged: (val) {
                              email = val;
                            },
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (val) => val.length < 6
                                ? "Password must be 6+ characters"
                                : null,
                            decoration: InputDecoration(hintText: "Password"),
                            onChanged: (val) {
                              password = val;
                            },
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          GestureDetector(
                            onTap: () {
                              getandSignIn();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Need to create an account?',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 17)),
                              GestureDetector(
                                onTap: () {
                                  widget.changeView();
                                },
                                child: Container(
                                  child: Text('Sign Up',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          decoration: TextDecoration.underline,
                                          fontSize: 17)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  )
                ],
              ),
      ),
    );
  }
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}
