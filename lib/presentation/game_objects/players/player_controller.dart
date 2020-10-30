import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/gen/index.dart';
import 'package:fortnight/presentation/config.dart';
import 'package:fortnight/presentation/messages/index.dart';

import 'player.dart';
import 'weapons/index.dart';

/// 自分のコントローラ
class PlayerController extends PositionComponent
    with
        HasGameRef,
        Tapable,
        ComposedComponent,
        Resizable,
        MessageControllerMixin {
  PlayerController() {
    _fetch();
  }

  Player get player => _player;
  Player _player;

  Size _screenSize;
  KentikuController _kentikuController;

  int get comboCount => _comboCount;
  int _comboCount = 0;

  StreamSubscription<CollisionMessageState> _collisionDisposer;

  @override
  void resize(Size size) {
    _screenSize = size;
    if (_player == null) {
      _createPlayer();
    }
    print('resize $size');
  }

  Future<void> dispose() async {
    await _collisionDisposer.cancel();
    await _kentikuController.dispose();
  }

  void onAttackEnemy(PositionComponent enemy) {
    _comboSound();
    if (_comboCount < 5) {
      final superMode = messageController.fetchSuperMode.value;
      messageController.onCollision.add(
        CollisionMessageState(
          from: this,
          to: enemy,
          damagePoint: superMode
              ? PlayerConfig.attackDamage * 10
              : PlayerConfig.attackDamage,
        ),
      );
      _comboCount += 1;
    } else {
      _comboCount = 0;
    }
  }

  void onCreateKentiku() {
    if (_kentikuController == null) {
      return;
    }
    _kentikuController.onCreate();
  }

  void _fetch() {
    _collisionDisposer ??= messageController.fetchCollision
        .where((event) => event.to is Player)
        .listen((event) {
      if (_player != null && _player.hp > 0) {
        _player.hp = max(_player.hp - event.damagePoint, 0);
        print('player_hp ${_player.hp}');
        if (_player.hp <= 0) {
          Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.bomb2));
          Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.death1));
          messageController.onGameOver.add(true);
        }
      }
    });
  }

  void _createPlayer() {
    const playerWidth = 96.0;
    const playerHeight = 128.0;
    const playerX = 16.0;
    final playerY = _screenSize.height / 2 - playerHeight + 16;
    _player = Player(
      x: playerX,
      y: playerY,
      width: playerWidth,
      height: playerHeight,
    );
    _kentikuController = KentikuController(playerRect: _player.toRect());
    components..add(_player)..add(_kentikuController);
  }

  void _comboSound() {
    if (_comboCount == 0) {
      Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.punch0));
    } else if (_comboCount == 1) {
      Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.punch0));
    } else if (_comboCount == 2) {
      Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.punch1));
    } else if (_comboCount == 3) {
      Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.punch0));
    } else if (_comboCount == 4) {
      Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.punch2));
    }
  }
}
