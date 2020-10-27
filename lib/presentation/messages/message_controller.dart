import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'states.dart';

class MessageController {
  factory MessageController() {
    return _instance ??= MessageController._();
  }

  MessageController._();
  static MessageController _instance;

  final _scene = PublishSubject<SceneState>();
  Stream<SceneState> get fetchScene => _scene;
  Sink<SceneState> get onScene => _scene.sink;

  final _collision = PublishSubject<CollisionMessageState>();
  Stream<CollisionMessageState> get fetchCollision => _collision;
  Sink<CollisionMessageState> get onCollision => _collision.sink;

  final _kentiku = PublishSubject<ComponentMessageState>();
  Stream<ComponentMessageState> get fetchKentiku => _kentiku;
  Sink<ComponentMessageState> get onKentiku => _kentiku.sink;

  final _gameOver = PublishSubject<bool>();
  Stream<bool> get fetchGameOver => _gameOver;
  Sink<bool> get onGameOver => _gameOver.sink;

  final _gameClear = PublishSubject<bool>();
  Stream<bool> get fetchGameClear => _gameClear;
  Sink<bool> get onGameClear => _gameClear.sink;

  final _superMode = BehaviorSubject<bool>.seeded(true); // TODO(shohei): false
  ValueStream<bool> get fetchSuperMode => _superMode;
  Sink<bool> get onSuperMode => _superMode.sink;

  Future dispose() async {
    await _scene.close();
    await _collision.close();
    await _kentiku.close();
    await _gameOver.close();
    await _gameClear.close();
    await _superMode.close();
  }
}
