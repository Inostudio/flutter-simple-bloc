import 'dart:async';

class SomeService {
  static SomeService _instance;

  static SomeService getInstance() {
    if (_instance == null) {
      _instance = SomeService._();
    }
    return _instance;
  }

  // ignore: close_sinks
  final _valueSubject = StreamController<bool>.broadcast();

  Sink<bool> get inValue => _valueSubject.sink;
  Stream<bool> get outValue => _valueSubject.stream;

  SomeService._();
}
