import 'package:flutter/material.dart';
class routes {
  static Route createRoute(Widget widget) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 300),
      reverseTransitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route createRoute2(Widget widget) {
    return PageRouteBuilder(
      transitionDuration: Duration(seconds: 2),
      reverseTransitionDuration: Duration(seconds: 2),
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: 0.0, end: 1.0).chain(
            CurveTween(curve: curve));

        return FadeTransition(
         // position: animation.drive(tween),
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}