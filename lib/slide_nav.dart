import 'package:flutter/material.dart';

class SlideNav extends PageRouteBuilder {
  Widget widget;
  SlideNav({this.widget})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionDuration: Duration(milliseconds: 200),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            Animation<Offset> _offsetAnimation =
                Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                    .animate(animation);
            return SlideTransition(
              position: _offsetAnimation,
              child: child,
            );
          },
        );
}
