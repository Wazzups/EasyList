import 'package:flutter/material.dart';
import 'ui/login.dart';

main(List<String> args) {
  runApp(MaterialApp(
      title: "Flutter Login",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: LoginScreen(),
      )));
}
