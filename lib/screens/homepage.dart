import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:todo_app/database_helper.dart';
import 'package:todo_app/screens/taskpage.dart';
import 'package:todo_app/slide_nav.dart';
import 'package:todo_app/user_simple_preferences.dart';
import '../main.dart';
import '../widgets.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  ScrollController _scrollController = new ScrollController();

  String username = '';

  @override
  void initState() {
    username = UserSimplePreferences.getUsername() ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.green, Colors.teal, Colors.green],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 12.0),
                        child: Image.asset(
                          'assets/images/logo_3.png',
                        ),
                        width: 150.0,
                        height: 150.0,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 26.0, horizontal: 16.0),
                          child: Text(
                            'Welcome $username!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTask(),
                      builder: (context, snapshot) {
                        return Container(
                          padding: EdgeInsets.only(top: 50.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFF3F3F3),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100.0),
                            ),
                          ),
                          child: ScrollConfiguration(
                            behavior: NoGlowBehaviour(),
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 10.0),
                                  child: FocusedMenuHolder(
                                    blurSize: 3,
                                    menuOffset: 6.0,
                                    menuWidth:
                                        MediaQuery.of(context).size.width -
                                            48.0,
                                    menuItems: <FocusedMenuItem>[
                                      FocusedMenuItem(
                                        title: Text(
                                          'Update Task',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        trailingIcon: Icon(
                                          Icons.update_rounded,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          HapticFeedback.vibrate();
                                          Route route = SlideNav(
                                              widget: Taskpage(
                                            task: snapshot.data[index],
                                          ));
                                          Navigator.push(context, route)
                                              .then((value) {
                                            setState(() {});
                                          });
                                        },
                                      ),
                                      FocusedMenuItem(
                                        backgroundColor: Colors.redAccent,
                                        title: Text(
                                          'Delete Task',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        trailingIcon: Icon(
                                          Icons.delete_forever_rounded,
                                          color: Colors.white,
                                        ),
                                        onPressed: () async {
                                          HapticFeedback.vibrate();
                                          await _dbHelper.deleteTask(
                                              snapshot.data[index].id);
                                          await flutterLocalNotificationsPlugin
                                              .cancel(snapshot.data[index].id);
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                    onPressed: () {
                                      HapticFeedback.vibrate();
                                      Route route = SlideNav(
                                          widget: Taskpage(
                                        task: snapshot.data[index],
                                      ));
                                      Navigator.push(context, route)
                                          .then((value) {
                                        setState(() {});
                                      });
                                    },
                                    child: TaskCardWidget(
                                      title: snapshot.data[index].title,
                                      desc: snapshot.data[index].description,
                                      date: snapshot.data[index].date,
                                      notify: snapshot.data[index].notify,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.vibrate();
                    Route route = SlideNav(widget: Taskpage(task: null));
                    Navigator.push(context, route).then((value) {
                      setState(() {
                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut);
                      });
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.green, Colors.teal, Colors.green],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          )
                        ]),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 24.0),
                      child: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.green,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
