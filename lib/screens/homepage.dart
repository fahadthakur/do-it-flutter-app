import 'package:flutter/material.dart';
import 'package:todo_app/database_helper.dart';
import 'package:todo_app/screens/taskpage.dart';
import 'package:todo_app/user_simple_preferences.dart';
import '../widgets.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

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
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          color: Color(0xFFECECEC),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20.0, top: 32.0),
                        child: Image.asset(
                          'assets/images/logo_1.png',
                        ),
                        width: 100.0,
                        height: 100.0,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Welcome $username!',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Divider(
                      thickness: 2.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'To create a task click on the green add button below.',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTask(),
                      builder: (context, snapshot) {
                        return ScrollConfiguration(
                          behavior: NoGlowBehaviour(),
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Taskpage(
                                            task: snapshot.data[index])),
                                  ).then((value) {
                                    setState(() {});
                                  });
                                },
                                child: TaskCardWidget(
                                  title: snapshot.data[index].title,
                                  desc: snapshot.data[index].description,
                                  date: snapshot.data[index].date,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Taskpage(task: null)))
                      .then((value) {
                    setState(() {});
                  }),
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.green[400]],
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, 1.0),
                      ),
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 40.0,
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
