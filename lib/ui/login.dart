import 'package:flutter/material.dart';
import 'login/loginPage.dart';
import 'home/home_page.dart';
import 'signup/signup_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return HomePage(context);
  }
}
