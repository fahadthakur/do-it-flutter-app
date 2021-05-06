import 'package:flutter/material.dart';
import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'IntroScreen.dart';
import 'homepage.dart';

class Splash extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    String uname = (prefs.getString('username') ?? '');

    if (_seen && uname != '') {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Homepage()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new IntroScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
