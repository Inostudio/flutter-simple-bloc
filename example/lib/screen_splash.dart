import 'package:flutter/material.dart';
import 'package:flutter_simple_bloc/flutter_simple_bloc.dart';
import 'package:flutter_state_lifecycle/my_app.dart';

class ScreenSplash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends StateWithSubscription<ScreenSplash> {
  @override
  void onStart() {
    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.of(context).pushReplacementNamed("/first");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }

  @override
  NavigationObserver getNavigatorObserver() => MyApp.navigation;
}
