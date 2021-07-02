import 'package:flutter/material.dart';
import 'util/subscription_mixin.dart';
import 'bloc_base.dart';

abstract class BlocContextBase<T extends BlocBase> with SubscriptionMixin {
  void subscribe(T bloc, BuildContext Function() contextFn);

  @mustCallSuper
  void dispose() {
    cancelSubscriptions();
  }
}
