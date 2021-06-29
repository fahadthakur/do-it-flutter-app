import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/database_helper.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class Taskpage extends StatefulWidget {
  final Task task;
  Taskpage({@required this.task});
  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  String _title = '';
  String _todo = '';
  String _description = '';
  String _deadlineDate = '';
  String _notifyDate = '';
  int _taskid = 0;
  DatabaseHelper _dbHelper = DatabaseHelper();

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _dateFocus;
  FocusNode _todoFocus;

  bool _contentVisible = false;

  DateTime _date = DateTime.now();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  final format = DateFormat("MMM dd, yyy | HH:mm");
  DateTime _remindDate = DateTime.now();

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    if (widget.task != null) {
      _contentVisible = true;
      _title = widget.task.title;
      _description = widget.task.description;
      _taskid = widget.task.id;
      _deadlineDate = widget.task.date;
      _notifyDate = widget.task.notify;
    }
    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();
    _todoFocus.addListener(_onTodoFocus);

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();
    super.dispose();
  }

  void scheduleNotification(DateTime date) async {
    DateTime scheduledNotificationDateTime = date;

    var androidPlatofrmChannelSpecifics = AndroidNotificationDetails(
      'Todo-notfication', //channel id
      'Todo-notfication', // channel name
      'Channel for todo notificiations', //channel description
      priority: Priority.max,
      importance: Importance.max,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
    );

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatofrmChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
      _taskid,
      'Task due!',
      'Your task $_title is due. Be sure to complete it!',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(2100));

    if (date != null) {
      setState(() {
        _date = date;
      });
      _deadlineDate = _dateFormatter.format(date);
      await _dbHelper.updateTaskDate(_taskid, _deadlineDate);
    }
  }

  _scrollToEnd() async {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  void _onTodoFocus() {
    if (_todoFocus.hasFocus) {
      _scrollToEnd();
    }
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.green, Colors.teal, Colors.green],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft),
          ),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: Color(0xFFF3F3F3),
            margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 50.0),
            child: Stack(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 24.0, bottom: 6.0),
                        child: Row(
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
                            Expanded(
                              child: TextField(
                                focusNode: _titleFocus,
                                onChanged: (value) {
                                  _title = value;
                                },
                                onSubmitted: (value) async {
                                  _title = value;
                                  if (_title != '') {
                                    if (widget.task == null) {
                                      Task _newTask = Task(title: _title);
                                      _taskid =
                                          await _dbHelper.insertTask(_newTask);
                                      setState(() {
                                        _contentVisible = true;
                                        _title = value;
                                      });
                                    } else {
                                      await _dbHelper.updateTaskTitle(
                                          _taskid, _title);
                                    }
                                  }
                                  _descriptionFocus.requestFocus();
                                },
                                controller: TextEditingController()
                                  ..text = _title,
                                decoration: InputDecoration(
                                  hintText: 'Enter Task Title',
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _contentVisible,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 6.0),
                          child: TextField(
                            focusNode: _descriptionFocus,
                            onChanged: (value) async {
                              _description = value;
                              if (_taskid != 0) {
                                await _dbHelper.updateTaskDescription(
                                    _taskid, _description);
                              }
                            },
                            onSubmitted: (value) {
                              _dateFocus.requestFocus();
                            },
                            controller: TextEditingController()
                              ..text = _description,
                            decoration: InputDecoration(
                              hintText: 'Enter description for the task.',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 24.0),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _contentVisible,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 24.0),
                          child: TextField(
                            readOnly: true,
                            controller: TextEditingController()
                              ..text = _deadlineDate,
                            focusNode: _dateFocus,
                            onTap: () {
                              _handleDatePicker();
                            },
                            decoration: InputDecoration(
                              hintText: 'Task Deadline',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 24.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              icon: Icon(
                                Icons.calendar_today_rounded,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _contentVisible,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 24.0),
                          child: DateTimeField(
                            decoration: InputDecoration(
                              hintText: 'Set a reminder notification',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 24.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              icon: Icon(
                                Icons.notifications_on_rounded,
                                color: Colors.green,
                              ),
                            ),
                            format: format,
                            controller: TextEditingController()
                              ..text = _notifyDate,
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(DateTime.now().year,
                                      DateTime.now().month, DateTime.now().day),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );
                                _remindDate = DateTimeField.combine(date, time);
                                _notifyDate = format.format(_remindDate);
                                await _dbHelper.updateTaskNotify(
                                    _taskid, _notifyDate);
                                scheduleNotification(_remindDate);
                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
                            },
                            onChanged: (value) async {
                              if (value == null) {
                                await _dbHelper.updateTaskNotify(_taskid, '');
                                await flutterLocalNotificationsPlugin
                                    .cancel(_taskid);
                              }
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _contentVisible,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 24.0),
                          child: Row(
                            children: [
                              Container(
                                width: 20.0,
                                height: 20.0,
                                margin: EdgeInsets.only(
                                  right: 12.0,
                                ),
                                child: Icon(
                                  Icons.check_box_outline_blank_rounded,
                                  color: Colors.green,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: TextField(
                                    focusNode: _todoFocus,
                                    controller: TextEditingController()
                                      ..text = "",
                                    onChanged: (value) {
                                      _todo = value;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Enter Todo Item...',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_todo != '') {
                                    if (_taskid != 0) {
                                      DatabaseHelper _dbHelper =
                                          DatabaseHelper();
                                      Todo _newTodo = Todo(
                                          title: _todo,
                                          isDone: 0,
                                          taskId: _taskid);
                                      await _dbHelper.insertTodo(_newTodo);
                                      _todo = '';

                                      setState(() {
                                        Future.delayed(
                                            Duration(milliseconds: 150), () {
                                          _scrollToEnd();
                                        });
                                      });
                                    }
                                  }
                                },
                                child: Text('Add'),
                                style: ElevatedButton.styleFrom(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _contentVisible,
                        child: FutureBuilder(
                          initialData: [],
                          future: _dbHelper.getTodos(_taskid),
                          builder: (context, snapshot) {
                            return Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      //switch isDOne to true
                                      if (snapshot.data[index].isDone == 0) {
                                        await _dbHelper.updateTodoDone(
                                            snapshot.data[index].id, 1);
                                      } else {
                                        await _dbHelper.updateTodoDone(
                                            snapshot.data[index].id, 0);
                                      }
                                      setState(() {});
                                    },
                                    child: TodoWidget(
                                      text: snapshot.data[index].title,
                                      isDone: snapshot.data[index].isDone == 0
                                          ? false
                                          : true,
                                      id: snapshot.data[index].id,
                                      update: _update,
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
                ),
                Visibility(
                  visible: _contentVisible,
                  child: Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: GestureDetector(
                      onTap: () {
                        if (_taskid != 0) {
                          HapticFeedback.vibrate();
                          _showDialog();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.red[800],
                                Colors.red,
                                Colors.red[800]
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 18.0),
                          child: Container(
                            width: 45.0,
                            height: 45.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.red,
                              size: 30.0,
                            ),
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
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task?'),
          content: Text('This action cannot be undone.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
              style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _dbHelper.deleteTask(_taskid);
                await flutterLocalNotificationsPlugin.cancel(_taskid);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0)),
              ),
            ),
          ],
        );
      },
    );
  }
}
