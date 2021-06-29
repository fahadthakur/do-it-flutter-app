import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/screens/homepage.dart';
import 'package:todo_app/user_simple_preferences.dart';

class NameEditScreen extends StatefulWidget {
  final editName;

  const NameEditScreen({Key key, this.editName}) : super(key: key);
  @override
  _NameEditScreenState createState() => _NameEditScreenState();
}

class _NameEditScreenState extends State<NameEditScreen> {
  final _formkey = GlobalKey<FormState>();
  String _username = '';

  _submit() async {
    if (_formkey.currentState.validate()) {
      await UserSimplePreferences.setUsername(_username);
      FocusScopeNode currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      Navigator.pop(context);
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
    Function editName = widget.editName;
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
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        HapticFeedback.vibrate();
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(24.0),
                                        child: Icon(
                                          Icons.arrow_back_ios_rounded,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "CHANGE USERNAME",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
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
                                            hintText: 'Enter a new username!',
                                          ),
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.green,
                                          ),
                                          validator: (_username) => _username
                                                  .trim()
                                                  .isEmpty
                                              ? 'Please enter your new username'
                                              : null,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 24.0),
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              _submit();
                                              editName();
                                            },
                                            label: Text(
                                              'Update Username',
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
                                      Text(
                                          'Change your username as you wish! This will be displayed on the homepage, so keep it short and simple :)')
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
