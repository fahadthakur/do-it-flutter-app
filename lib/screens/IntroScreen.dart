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
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.green, Colors.teal, Colors.green],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft)),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          color: Color(0xFFF3F3F3),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text(
                                  "WELCOME  TO  DO-IT!",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Image.asset('assets/images/logo_3.png'),
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
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              _submit();
                                            },
                                            label: Text(
                                              'Save Username',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            icon: Icon(
                                              Icons.account_circle_rounded,
                                              color: Colors.white,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          15.0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24.0),
                                  child: Column(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                            text:
                                                'Start off by saving your username. ',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: 'To create a task ',
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 16.0)),
                                              TextSpan(
                                                  text:
                                                      'from the homepage, click on the add icon.',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16.0)),
                                              TextSpan(
                                                  text:
                                                      '\nTo update or delete a task, ',
                                                  style: TextStyle(
                                                      color: Colors.deepOrange,
                                                      fontSize: 16.0)),
                                              TextSpan(
                                                  text:
                                                      'click on the task card and follow the prompts. Have fun in accomplishing your daily tasks, wohoo! ',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16.0))
                                            ]),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
