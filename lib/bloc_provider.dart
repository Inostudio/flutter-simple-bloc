import 'package:flutter/widgets.dart';
import 'bloc_base.dart';
import 'bloc_context_base.dart';

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    @required this.child,
    @required this.bloc,
    @required this.blocContext,
    Key key,
  }) : super(key: key);

  final T bloc;
  final Widget child;
  final BlocContextBase<T> blocContext;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final BlocProvider<T> provider = context.findAncestorWidgetOfExactType();
    return provider.bloc;
  }
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  void initState() {
    super.initState();
    widget.blocContext.subscribe(widget.bloc, () => context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    widget.blocContext.dispose();
    super.dispose();
  }
}
