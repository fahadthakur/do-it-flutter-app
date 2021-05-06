import 'package:flutter/material.dart';
import 'package:todo_app/screens/homepage.dart';
import 'package:todo_app/user_simple_preferences.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final _formkey = GlobalKey<FormState>();
  String _username = '';

  _submit() async {
    if (_formkey.currentState.validate()) {
      await UserSimplePreferences.setUsername(_username);
      FocusScopeNode currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      Navigator.push(
              context, MaterialPageRoute(builder: (context) => Homepage()))
          .then((value) {
        setState(() {});
      });
    }
  }

  bool checkForm() {
    if (UserSimplePreferences.getUsername() != null) {
      if (_formkey.currentState.validate()) {
        return true;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            color: Colors.white,
            child: Stack(
              children: [
                ListView(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Image.asset('assets/images/logo_2.png'),
                            Text(
                              "Welcome to Do-It!",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 24.0),
                              child: Form(
                                key: _formkey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      onChanged: (value) {
                                        _username = value.trim();
                                      },
                                      decoration: InputDecoration(
                                        hintText:
                                            'Enter your name for a personalized experience!',
                                      ),
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.green,
                                      ),
                                      validator: (_username) =>
                                          _username.trim().isEmpty
                                              ? 'Please enter your name'
                                              : null,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 24.0),
                                      child: TextButton.icon(
                                        onPressed: () {
                                          _submit();
                                        },
                                        label: Text(
                                          'Save Username',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        icon: Icon(
                                          Icons.account_circle_rounded,
                                          color: Colors.white,
                                        ),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Start off by saving your username. Then click on the green home button. To create a task from the homepage, click on the green add icon.",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.grey),
                                  ),
                                  Text(
                                    "To update or delete a task click on the task card and follow the prompts. Have fun accomplishsing your tasks, wohoo!",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
