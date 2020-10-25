import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:fortnight/gen/index.dart';
import 'package:fortnight/presentation/game_objects/enemies/index.dart';
import 'package:fortnight/presentation/game_objects/players/index.dart';
import 'package:fortnight/presentation/messages/index.dart';

class Stage1SceneController extends BaseGame
    with MultiTouchTapDetector, HasTapableComponents, MessageControllerMixin {
  Stage1SceneController() {
    _configure();
  }

  PlayerController _playerController;
  Enemy1Controller _enemy1controller;
  PlayerAreaController _playerAreaController;
  AudioPlayer _bgm;

  bool _isGameClear = false;
  bool _isGameStart = true;
  bool _isTapped = false;

  @override
  void onTapDown(int pointerId, TapDownDetails d) {
    if (!_isGameStart || _isGameClear) {
      return;
    }

    // TODO(shohei): 1回タップで2回発火してしまうので制御
    if (_isTapped) {
      _isTapped = false;
      return;
    }
    _isTapped = true;

    if (_playerAreaController.isTapKentikuButton(d)) {
      _createKentiku();
    }

    if (_playerAreaController.isTapAttackButton(d)) {
      _attackToEnemy();
    }
  }

  @override
  void update(double t) {
    super.update(t);
    _updateCollisionBullets();
  }

  Future<void> _configure() async {
    _playerController = PlayerController();
    _enemy1controller = Enemy1Controller();
    _playerAreaController = PlayerAreaController();
    this
      ..add(_playerController)
      ..add(_enemy1controller)
      ..add(_playerAreaController);
    _bgm = await Flame.audio.loopLongAudio(
        Assets.audio.filename(Assets.audio.bgm.bgm2),
        volume: .25);
    _fetch();
  }

  void _attackToEnemy() {
    _playerController.onAttackEnemy(_enemy1controller.enemy1);
  }

  void _createKentiku() {
    _playerController.onCreateKentiku();
  }

  void _updateCollisionBullets() {
    final player = _playerController.player;
    if (player == null) {
      return;
    }
    _enemy1controller.onUpdateCollisionBullets(player);
  }

  void _fetch() {
    messageController.fetchGameOver.listen((event) async {
      _isGameStart = !event;
      if (event) {
        await _bgm.pause();
        await _bgm.seek(Duration.zero);
      }
    });
    messageController.fetchGameClear.listen((event) {
      _isGameClear = event;
      // TODO(shohei): クリア画面へ
    });
  }
}
