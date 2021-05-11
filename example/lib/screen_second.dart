import 'package:flutter/material.dart';
import 'package:flutter_simple_bloc/flutter_simple_bloc.dart';
import 'package:flutter_state_lifecycle/some_service.dart';
import 'my_app.dart';

class ScreenSecond extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenSecondState();
}

class _ScreenSecondState extends StateWithSubscription<ScreenSecond> {
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
            Text("SecondScreen"),
            SizedBox(height: 24),
            RaisedButton(
              onPressed: _onChange,
              child: Text("change"),
            ),
            SizedBox(height: 24),
            RaisedButton(
              onPressed: _gotoBack,
              child: Text("<"),
            )
          ],
        ),
      ),
    );
  }

  void _gotoBack() {
    Navigator.of(context).pop();
  }

  void _onChange() {
    SomeService.getInstance().inValue.add(true);
  }
}
