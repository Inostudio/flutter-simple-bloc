import 'package:flutter/widgets.dart';
import 'extension/extension_subscription.dart';
import 'widget_state_type.dart';

abstract class StateWithSubscription<A extends StatefulWidget> extends State<A>
    with ExtensionSubscription, RouteAware {
  @protected
  final initWithSubscription = true;

  @protected
  WidgetStateType widgetState = WidgetStateType.initializing;

  @override
  void initState() {
    super.initState();
    if (initWithSubscription) {
      onCreate();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        subscribeNavigatorObserver();
        onStart();
      });
    }
  }

  void subscribeNavigatorObserver() {
    final route = ModalRoute.of(context);
    if (route != null) {
      getNavigatorObserver().subscribe(this, ModalRoute.of(context));
    }
    onWidgetStateChange(WidgetStateType.visible);
  }

  RouteObserver getNavigatorObserver();

  /// State is created but BuildContext is still not initialized
  /// Here we can initialize subscriptions
  void onCreate() {}

  /// State is created and BuildContext is properly initialized
  /// Here we can call BLoC startup
  void onStart() {}

  @protected
  @mustCallSuper
  void onWidgetStateChange(WidgetStateType state) {
    widgetState = state;
  }

  /// Subscribe Function to Stream and Act when State is visible in foreground
  void streamSubscribeFn<T>(Stream<T> stream, Function(T) fn) {
    addSubscription(stream.listen((event) {
      if (widgetState == WidgetStateType.visible) {
        fn(event);
      }
    }));
  }

  @override
  @protected
  void didPopNext() {
    onWidgetStateChange(WidgetStateType.visible);
  }

  @override
  @protected
  void didPushNext() {
    onWidgetStateChange(WidgetStateType.invisible);
  }

  @override
  @mustCallSuper
  void dispose() {
    onWidgetStateChange(WidgetStateType.destroying);
    getNavigatorObserver().unsubscribe(this);
    super.cancelSubscriptions();
    super.dispose();
  }
}
