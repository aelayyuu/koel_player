import 'dart:async';

mixin StreamSubscriber {
  final List<StreamSubscription> _subscriptions = [];

  void unsubscribeAll() {
    for (StreamSubscription streamSubscription in _subscriptions) {
      streamSubscription.cancel();
    }
  }

  void subscribe(StreamSubscription sub) => _subscriptions.add(sub);
}
