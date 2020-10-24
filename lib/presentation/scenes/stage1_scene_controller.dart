import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/gestures.dart';
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

  bool _isTapped = false;

  @override
  void onTapDown(int pointerId, TapDownDetails d) {
    // TODO(shohei): 1回タップで2回発火してしまうので制御
    if (_isTapped) {
      _isTapped = false;
      return;
    }
    _isTapped = true;

    if (_playerAreaController.kentikuButton
        .toRect()
        .contains(d.localPosition)) {
      _playerAreaController.kentikuButton.onTapDown(d);
      _createKentiku();
    }

    if (_playerAreaController.attackButton.toRect().contains(d.localPosition)) {
      _playerAreaController.attackButton.onTapDown(d);
      _attackToEnemy();
    }
  }

  @override
  void update(double t) {
    super.update(t);
    _updateRemoveEnemyBullets();
  }

  void _attackToEnemy() {
    _playerController.onAttackEnemy(_enemy1controller.enemy1);
  }

  void _createKentiku() {
    _playerController.onCreateKentiku();
  }

  void _updateRemoveEnemyBullets() {
    // TODO(shohei): 建築とプレイヤーの当たり制御を考える
    final player = _playerController.player;
    if (player == null) {
      return;
    }
    _enemy1controller.onUpdateRemoveBullets(player);
  }
}
