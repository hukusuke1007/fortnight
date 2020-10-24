import 'dart:ui';

import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
// ignore: implementation_imports
import 'package:flutter/src/gestures/tap.dart';
import 'package:fortnight/presentation/game_objects/enemies/index.dart';
import 'package:fortnight/presentation/game_objects/players/index.dart';

class Stage1SceneController extends BaseGame
    with MultiTouchTapDetector, HasTapableComponents {
  Stage1SceneController() {
    _playerController = PlayerController();
    _enemy1controller = Enemy1Controller();
    _playerAreaController = PlayerAreaController();
    this
      ..add(_playerController)
      ..add(_enemy1controller)
      ..add(_playerAreaController);
  }

  PlayerController _playerController;
  Enemy1Controller _enemy1controller;
  PlayerAreaController _playerAreaController;

  @override
  void onTapDown(int pointerId, TapDownDetails details) {}

  @override
  void update(double t) {
    super.update(t);
    _updateRemoveEnemyBullets();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // print('render $canvas');
  }

  void _updateRemoveEnemyBullets() {
    final player = _playerController.player;
    if (player == null) {
      return;
    }
    _enemy1controller.updateRemoveBullets(player);
  }

  void _collisionEnemy() {
    // TODO
  }
}
