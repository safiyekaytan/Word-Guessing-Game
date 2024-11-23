import 'dart:async';

class MessageManager {
  static final MessageManager _instance = MessageManager._internal();
  factory MessageManager() => _instance;

  MessageManager._internal();

  final _messageStreamController = StreamController<String>.broadcast();

  Stream<String> get messageStream => _messageStreamController.stream;

  void addMessage(String message) {
    _messageStreamController.add(message);
  }

  void dispose() {
    _messageStreamController.close();
  }
}
