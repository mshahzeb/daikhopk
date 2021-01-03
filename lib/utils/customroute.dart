import 'package:flutter/material.dart';

class MyFadeRoute<T> extends MaterialPageRoute<T> {
  MyFadeRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return new FadeTransition(opacity: animation, child: child);
  }
}