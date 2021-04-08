import 'package:flutter/material.dart';
import 'extension/extension_subscription.dart';
import 'bloc_base.dart';

abstract class BlocContextBase<T extends BlocBase> with ExtensionSubscription {
  void subscribe(T bloc, BuildContext Function() contextFn);

  @mustCallSuper
  void dispose() {
    cancelSubscriptions();
  }
}
