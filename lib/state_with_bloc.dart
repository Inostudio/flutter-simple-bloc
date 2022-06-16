import 'package:flutter/widgets.dart';
import 'bloc_base.dart';
import 'bloc_provider.dart';
import 'state_with_subscription.dart';
import 'widget_state_type.dart';

abstract class StateWithBloc<A extends StatefulWidget, B extends BlocBase>
    extends StateWithSubscription<A> {
  late B bloc;

  @override
  final initWithSubscription = false;

  @override
  void initState() {
    super.initState();
    if (BlocProvider.of<B>(context) == null) {
      throw Exception("Bloc can't be null!");
    }
    bloc = BlocProvider.of<B>(context)!;
    onCreate();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      subscribeNavigatorObserver();
      onStart();
    });
  }

  @override
  @mustCallSuper
  void onWidgetStateChange(WidgetStateType state) {
    super.onWidgetStateChange(state);
    bloc.onWidgetStateChange(state);
  }

  @override
  void dispose() {
    bloc.onWidgetStateChange(WidgetStateType.destroying);
    super.dispose();
  }
}
