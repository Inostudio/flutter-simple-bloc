import 'package:flutter/material.dart';
import 'package:flutter_simple_bloc/flutter_simple_bloc.dart';
import 'package:flutter_state_lifecycle/some_service.dart';
import 'my_app.dart';

class ScreenFirst extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenFirstState();
}

class _ScreenFirstState extends StateWithSubscription<ScreenFirst> {
  @override
  NavigationObserver getNavigatorObserver() {
    return MyApp.navigation;
  }

  @override
  void onStart() {
    streamSubscribeFn(SomeService.getInstance().outValue, (value) {
      print(">>> $runtimeType event=$value in state=${widgetState.value}.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("FirstScreen"),
            SizedBox(height: 24),
            RaisedButton(
              onPressed: _onChange,
              child: Text("change"),
            ),
            SizedBox(height: 24),
            RaisedButton(
              onPressed: _gotoSecond,
              child: Text(">"),
            )
          ],
        ),
      ),
    );
  }

  void _gotoSecond() {
    Navigator.of(context).pushNamed("/second");
  }

  void _onChange() {
    SomeService.getInstance().inValue.add(true);
  }
}
