import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:async/async.dart';
import 'util/subscription_mixin.dart';
import 'widget_state_type.dart';

abstract class BlocBase with SubscriptionMixin {
  final List<CancelableOperation> _workers = [];
  @protected
  WidgetStateType widgetState = WidgetStateType.initializing;

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

  void addWorker<T>(CancelableOperation<T> worker) {
    _workers.add(worker);
  }

  Future<bool> runWorkerV2<T>({
    required Future<T?> onRun,
    required Function(T?) onResult,
    Function(dynamic, StackTrace)? onError,
    bool forceResult = false,
  }) {
    final result = Completer<bool>();
    final cancelableWorker = CancelableOperation.fromFuture(
      onRun.then((value) {
        return value;
      }).catchError((error, stack) {
        onError?.call(error, stack);
        return null;
      }),
      onCancel: () {
        result.complete(false);
      },
    );
    addWorker(cancelableWorker);
    cancelableWorker.value.then((value) {
      if (widgetState == WidgetStateType.visible ||
          (forceResult && widgetState != WidgetStateType.destroying)) {
        onResult(value);
      }
      result.complete(true);
    });
    return result.future;
  }

  void cancelWorkers() {
    _workers.forEach((worker) {
      if (worker.isCanceled == false) {
        worker.cancel();
      }
    });
    _workers.clear();
  }

  void dispose() {
    cancelWorkers();
    cancelSubscriptions();
  }
}
