import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validate/validate.dart';
import 'signup_data.dart';
import '../login/loginPage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  SignData _signUpData = new SignData();
  final GlobalKey<FormState> _formKey =
      new GlobalKey<FormState>(); //formKey to validate InputFields data

// Add validate email function.
  String _validateEmail(String value) {
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }
    return null;
  }

  // Add validate password function.
  String _validatePassword(String value) {
    if (value.length < 8) return 'The Password must be at least 8 characters.';

    return null;
  }

  // Add validate confirm password function.
  String _validateConfirmPassword(String value) {
    if (value.length < 8 && value != this._signUpData.password)
      return 'The Confirm Password must be the same';

    return null;
  }

  // Check form validation and return true if valid
  bool submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.

      print('Printing the signup data.');
      print('Email: ${_signUpData.email}');
      print('Password: ${_signUpData.password}');
      return true;
    }
    return false;
  }

  // Register new user on firebase if form valid
  Future validateAndSubmit() async {
    if (submit()) {
      try {
        FirebaseUser firebaseUser = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: this._signUpData.email,
                password: this._signUpData.password);
        debugPrint("Registered UID = " + firebaseUser.uid);
        _formKey.currentState.reset();
        var router = MaterialPageRoute(
          builder: (BuildContext context) => LoginPage(),
        );
        Navigator.of(context).push(router);
      } catch (e) {
        debugPrint(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.15), BlendMode.dstATop),
            image: AssetImage('assets/images/list.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: new Form(
          key: this._formKey,
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(60.0),
                child: Center(
                  child: Icon(
                    Icons.assignment,
                    color: Colors.red,
                    size: 55.0,
                  ),
                ),
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "EMAIL",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.mail_outline,
                            color: Colors.red,
                          ),
                          border: InputBorder.none,
                          hintText: 'example@gmail.com',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: this._validateEmail,
                        onSaved: (value) => this._signUpData.email = value,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "PASSWORD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        obscureText: true,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock_outline,
                            color: Colors.red,
                          ),
                          border: InputBorder.none,
                          hintText: '*********',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: this._validatePassword,
                        onSaved: (value) => this._signUpData.password = value,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "CONFIRM PASSWORD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        obscureText: true,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock_outline,
                            color: Colors.red,
                          ),
                          border: InputBorder.none,
                          hintText: '*********',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: this._validateConfirmPassword,
                        onSaved: (value) =>
                            this._signUpData.confirmPassword = value,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: new FlatButton(
                      child: new Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onPressed: () => {},
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 40.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Colors.redAccent,
                        onPressed: validateAndSubmit,
                        child: new Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  "SIGN UP",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
