import 'package:flutter/material.dart';
import 'home/home_page.dart';
import 'login/loginPage.dart';
import 'signup/signup_page.dart';
import 'mainhome/mainhome.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EasyList",
      home: MainHome(),
    );
  }
}
