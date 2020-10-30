import 'dart:async';

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
import 'package:fortnight/presentation/mixins/index.dart';
import 'package:fortnight/presentation/parts/label/game_clear_label.dart';
import 'package:fortnight/presentation/parts/label/game_over_label.dart';

class Stage1SceneController extends BaseGame
    with
        MultiTouchTapDetector,
        HasTapableComponents,
        MessageControllerMixin,
        TapMixin {
  Stage1SceneController() {
    _configure();
  }

  PlayerController _playerController;
  EnemyController _enemyController;
  PlayerAreaController _playerAreaController;
  AudioPlayer _bgm;

  bool _isGameClear = false;
  bool _isGameStart = true;
  bool _isEnableAttack = true;

  StreamSubscription<bool> _gameOverDisposer;
  StreamSubscription<bool> _gameClearDisposer;
  StreamSubscription<ComponentMessageState> _kentikuDisposer;

  @override
  void onTapDown(int pointerId, TapDownDetails d) {
    if (!_isGameStart || _isGameClear) {
      return;
    }

    // TODO(shohei): 1回タップで2回発火してしまうので制御
    if (isChattering) {
      return;
    }

    if (_playerAreaController.isTapKentikuButton(d)) {
      _createKentiku();
    }

    if (_playerAreaController.isTapAttackButton(d)) {
      final superMode = messageController.fetchSuperMode.value;
      if (_isEnableAttack || superMode) {
        _attackToEnemy();
      } else {
        Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.punchSwing1));
      }
    }
  }

  @override
  void update(double t) {
    super.update(t);
    _updateCollisionBullets();
  }

  @override
  Future<void> onDetach() async {
    super.onDetach();
    await _playerController?.dispose();
    await _enemyController?.dispose();
    await _gameOverDisposer?.cancel();
    await _gameClearDisposer?.cancel();
    await _kentikuDisposer?.cancel();
    await _bgm.pause();
    await _bgm.seek(Duration.zero);
  }

  Future<void> _configure() async {
    _playerController = PlayerController();
    _enemyController = EnemyController();
    _playerAreaController = PlayerAreaController();
    this
      ..add(_playerController)
      ..add(_enemyController)
      ..add(_playerAreaController);
    _bgm = await Flame.audio.loopLongAudio(
        Assets.audio.filename(Assets.audio.bgm.bgm2),
        volume: .25);
    _fetch();
  }

  void _attackToEnemy() {
    _playerController.onAttackEnemy(_enemyController.enemy1);
  }

  void _createKentiku() {
    _playerController.onCreateKentiku();
  }

  void _updateCollisionBullets() {
    final player = _playerController.player;
    if (player == null) {
      return;
    }
    _enemyController.onUpdateCollisionBullets(player);
  }

  void _fetch() {
    _gameOverDisposer ??= messageController.fetchGameOver
        .where((event) => event)
        .listen((event) async {
      _isGameStart = !event;
      await _bgm.pause();
      await _bgm.seek(Duration.zero);
      add(GameOverLabel(screenSize: size));
      Future.delayed(const Duration(milliseconds: 3000), () {
        messageController.onScene.add(SceneState(type: SceneType.start));
      });
    });
    _gameClearDisposer ??= messageController.fetchGameClear
        .where((event) => _isGameClear != true)
        .listen((event) async {
      _isGameClear = event;
      await _bgm.pause();
      await _bgm.seek(Duration.zero);
      add(GameClearLabel(screenSize: size));
      await Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.gameClear));
      Future.delayed(const Duration(milliseconds: 8000), () {
        messageController.onScene.add(SceneState(type: SceneType.ending));
      });
    });
    _kentikuDisposer ??= messageController.fetchKentiku.listen((event) {
      _isEnableAttack = event.objectStateType == ObjectStateType.remove;
    });
  }
}
