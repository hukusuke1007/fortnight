import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'states.dart';

class MessageController {
  factory MessageController() {
    return _instance ??= MessageController._();
  }

  MessageController._();
  static MessageController _instance;

  final _collision = PublishSubject<CollisionMessageState>();
  Stream<CollisionMessageState> get fetchCollision => _collision;
  Sink<CollisionMessageState> get onCollision => _collision.sink;

  final _gameOver = PublishSubject<bool>();
  Stream<bool> get fetchGameOver => _gameOver;
  Sink<bool> get onGameOver => _gameOver.sink;

  final _gameClear = PublishSubject<bool>();
  Stream<bool> get fetchGameClear => _gameClear;
  Sink<bool> get onGameClear => _gameClear.sink;

  Future dispose() async {
    await _collision.close();
    await _gameOver.close();
    await _gameClear.close();
  }
}
