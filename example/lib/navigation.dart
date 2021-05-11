import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_simple_bloc/flutter_simple_bloc.dart';
import 'package:flutter_state_lifecycle/screen_first.dart';
import 'package:flutter_state_lifecycle/screen_second.dart';
import 'package:flutter_state_lifecycle/screen_splash.dart';

class Navigation extends NavigationObserver {

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (settings.name == "/") {
      return MaterialPageRoute(
        settings: settings,
        // maintainState: false,
        builder: (context) {
          return ScreenSplash();
        },
      );
    }
    if (settings.name == "/first") {
      return MaterialPageRoute(
        settings: settings,
        // maintainState: false,
        builder: (context) {
          return ScreenFirst();
        },
      );
    }
    if (settings.name == "/second") {
      return MaterialPageRoute(
        settings: settings,
        // maintainState: false,
        builder: (context) {
          return ScreenSecond();
        },
      );
    }
    return null;
  }
}
