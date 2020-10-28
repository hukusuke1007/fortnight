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
import 'package:fortnight/presentation/parts/index.dart';

import 'weapons/kentiku.dart';

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

  Size screenSize;
  Player get player =>
      components.firstWhere((value) => value is Player, orElse: () => null)
          as Player;
  KentikuController kentikuController;

  int get comboCount => _comboCount;
  int _comboCount = 0;

  @override
  void update(double t) {
    super.update(t);
  }

  @override
  void resize(Size size) {
    screenSize = size;
    if (player == null) {
      _createPlayer();
    }
    print('resize $size');
  }

  void onReset() {
    components.clear();
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
    if (kentikuController == null) {
      return;
    }
    kentikuController.onCreate();
  }

  void _fetch() {
    messageController.fetchCollision
        .where((event) => event.to is Player)
        .listen((event) {
      if (player != null && player.hp > 0) {
        player.hp = max(player.hp - event.damagePoint, 0);
        print('player_hp ${player.hp}');
        if (player.hp <= 0) {
          Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.bomb2));
          Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.death1));
          messageController.onGameOver.add(true);
        }
      }
    });
  }

  void _createPlayer() {
    const playerWidth = 120.0;
    const playerHeight = 120.0;
    const playerX = 16.0;
    final playerY = screenSize.height / 2 - playerHeight + 16;
    final player = Player(
      x: playerX,
      y: playerY,
      width: playerWidth,
      height: playerHeight,
    );
    kentikuController = KentikuController(playerRect: player.toRect());
    components..add(player)..add(kentikuController);
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

/// プレイヤー
class Player extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  Player({
    @required double x,
    @required double y,
    @required double width,
    @required double height,
  }) : _lifePointLabel = LifePointLabel(
          rect: Rect.fromLTWH(x, y, width, height),
        ) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    _rect = Rect.fromLTWH(x, y, width, height);
    _paint = Paint()..color = Colors.blue;
    hp = PlayerConfig.hp;
    add(_lifePointLabel);
  }
  final LifePointLabel _lifePointLabel;

  int _hp = 1;
  int get hp => _hp;
  set hp(int value) {
    _hp = value;
    _lifePointLabel.value = _hp;
  }

  Rect _rect;
  Paint _paint;

  @override
  void update(double t) {
    super.update(t);
  }

  @override
  void render(Canvas c) {
    super.render(c);
    c.drawRect(_rect, _paint);
  }

  @override
  bool destroy() {
    return hp <= 0;
  }
}
