import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/presentation/game_objects/weapons/kentiku.dart';
import 'package:fortnight/presentation/messages/index.dart';

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
    messageController.onCollision
        .add(CollisionMessageState(from: this, to: enemy, damagePoint: 1));
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
        if (player.hp == 0) {
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
}

/// プレイヤー
class Player extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  Player({
    @required this.x,
    @required this.y,
    @required this.width,
    @required this.height,
  }) {
    _rect = Rect.fromLTWH(x, y, width, height);
    _paint = Paint()..color = Colors.blue;
  }

  final double x;
  final double y;
  final double width;
  final double height;
  int hp = 100;

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
