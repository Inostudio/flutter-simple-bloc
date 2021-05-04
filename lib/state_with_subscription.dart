import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'extension/extension_subscription.dart';
import 'navigation_observer.dart';
import 'widget_state_type.dart';

abstract class StateWithSubscription<A extends StatefulWidget> extends State<A>
    with ExtensionSubscription, RouteAware {
  @protected
  final initWithSubscription = true;

  @protected
  final widgetState = ValueNotifier(WidgetStateType.initializing);

  @override
  void initState() {
    super.initState();
    if (initWithSubscription) {
      onCreate();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        subscribeNavigatorObserver();
        onStart();
      });
    }
  }

  void subscribeNavigatorObserver() {
    final route = ModalRoute.of(context);
    if (route != null) {
      getNavigatorObserver()?.subscribe(this, route);
    }
  }

  NavigationObserver getNavigatorObserver();

  /// State is created but BuildContext is still not initialized
  /// Here we can initialize subscriptions
  void onCreate() {}

  /// State is created and BuildContext is properly initialized
  /// Here we can call BLoC startup
  void onStart() {}

  @mustCallSuper
  void onWidgetStateChange(WidgetStateType state) {
    widgetState.value = state;
  }

  /// Subscribe Function to Stream and Act when State is visible in foreground
  void streamSubscribeFn<T>(Stream<T> stream, Function(T) fn) {
    addSubscription(stream.listen((event) {
      if (widgetState.value == WidgetStateType.visible) {
        fn(event);
      }
    }));
  }

  @override
  void didPopNext() {
    onWidgetStateChange(WidgetStateType.visible);
  }

  @override
  void didPush() {
    onWidgetStateChange(WidgetStateType.visible);
  }

  @override
  void didPop() {
    onWidgetStateChange(WidgetStateType.invisible);
  }

  @override
  void didPushNext() {
    onWidgetStateChange(WidgetStateType.invisible);
  }

  @override
  @mustCallSuper
  void dispose() {
    onWidgetStateChange(WidgetStateType.destroying);
    getNavigatorObserver()?.unsubscribe(this);
    super.cancelSubscriptions();
    super.dispose();
  }
}
