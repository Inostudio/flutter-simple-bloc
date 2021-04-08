import 'dart:async';

abstract class ExtensionSubscription {
  final List<StreamSubscription> _cleanUpSubscribers = [];

  void addSubscription(StreamSubscription subscription) {
    _cleanUpSubscribers.add(subscription);
  }

  void cancelSubscriptions() {
    _cleanUpSubscribers.forEach((e) {
      e.cancel();
    });
    _cleanUpSubscribers.clear();
  }
}
