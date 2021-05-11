import 'package:flutter/widgets.dart';

class NavigationObserver extends NavigatorObserver {
  final _listeners = <Route, RouteAware>{};

  void subscribe(RouteAware routeAware, Route route) {
    _listeners.putIfAbsent(route, () => routeAware);
    routeAware.didPush();
  }

  void unsubscribe(RouteAware routeAware) {
    _listeners.removeWhere((key, value) => value == routeAware);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _listeners[route]?.didPop();
    _listeners[previousRoute]?.didPopNext();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _listeners[previousRoute]?.didPushNext();
    _listeners[route]?.didPush();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _listeners[previousRoute]?.didPop();
    _listeners[route]?.didPop();
  }

  @override
  void didReplace({
    Route<dynamic>? newRoute,
    Route<dynamic>? oldRoute,
  }) {
    _listeners[oldRoute]?.didPop();
    _listeners[newRoute]?.didPush();
  }
}
