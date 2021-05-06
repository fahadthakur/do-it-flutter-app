import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
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
      0,
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
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (date != null) {
      setState(() {
        _date = date;
      });
      _deadlineDate = _dateFormatter.format(date);
      await _dbHelper.updateTaskDate(_taskid, _deadlineDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xFFECECEC),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 24.0, bottom: 6.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
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
                            controller: TextEditingController()..text = _title,
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
                      padding:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
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
                          icon: Icon(Icons.calendar_today_rounded),
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
                          hintText:
                              'When would you like to be reminded about the task?',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 24.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          icon: Icon(Icons.notifications_on_rounded),
                        ),
                        format: format,
                        controller: TextEditingController()..text = _notifyDate,
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
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
                            await flutterLocalNotificationsPlugin.cancel(0);
                          }
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
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
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextField(
                                focusNode: _todoFocus,
                                controller: TextEditingController()..text = "",
                                onChanged: (value) {
                                  _todo = value;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter Todo Item..',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  isDense: true,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_todo != '') {
                                if (_taskid != 0) {
                                  DatabaseHelper _dbHelper = DatabaseHelper();
                                  Todo _newTodo = Todo(
                                      title: _todo, isDone: 0, taskId: _taskid);
                                  await _dbHelper.insertTodo(_newTodo);
                                  _todo = '';
                                  setState(() {});
                                }
                              }
                            },
                            child: Text('Add'),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                      visible: _contentVisible, child: Divider(thickness: 2.0)),
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTodos(_taskid),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: ListView.builder(
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
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskid != 0) {
                        await _dbHelper.deleteTask(_taskid);
                        await flutterLocalNotificationsPlugin.cancel(0);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red, Colors.red[400]],
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0),
                        ),
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                        size: 40.0,
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
