import 'package:flutter/material.dart';

import 'database_helper.dart';

class TaskCardWidget extends StatelessWidget {
  final String title;
  final String desc;
  final String date;
  TaskCardWidget({this.title, this.desc, this.date});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "(No Task)",
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(desc ?? 'No Description added',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  height: 1.5,
                )),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(date ?? 'Task deadline not set.',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber,
                  height: 1.5,
                )),
          ),
        ],
      ),
    );
  }
}

class TodoWidget extends StatefulWidget {
  final String text;
  final int id;
  bool isDone;

  TodoWidget({Key key, this.text, this.isDone, this.id}) : super(key: key);
  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    String text = widget.text;
    bool isDone = widget.isDone;
    int id = widget.id;

    return ListTile(
      title: Text(
        text ?? 'Unnamed todo',
        style: TextStyle(
            color: isDone ? Colors.grey : Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            decoration:
                isDone ? TextDecoration.lineThrough : TextDecoration.none),
      ),
      leading: Checkbox(
        onChanged: (bool value) async {
          await _dbHelper.updateTodoDone(id, isDone == false ? 1 : 0);
          setState(() {
            widget.isDone = value;
            isDone = widget.isDone;
          });
        },
        value: isDone ?? false,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
