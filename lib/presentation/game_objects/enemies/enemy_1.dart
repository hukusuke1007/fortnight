import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/presentation/game_objects/weapons/bullet.dart';

/// 敵のコントローラ
class Enemy1Controller extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  Enemy1Controller() {}

  Size screenSize;
  Enemy1 get enemy1 =>
      components.firstWhere((value) => value is Enemy1, orElse: () => null)
          as Enemy1;

  @override
  void update(double t) {
    super.update(t);
  }

  @override
  void resize(Size size) {
    screenSize = size;
    if (enemy1 == null) {
      _createEnemy();
    }
    print('resize $size');
  }

  void reset() {
    components.clear();
  }

  void updateRemoveBullets(PositionComponent player) {
    components.whereType<Enemy1>().forEach((element) {
      element.removeBullet(player);
    });
  }

  void _createEnemy() {
    const enemyWidth = 120.0;
    const enemyHeight = 120.0;
    final enemyX = screenSize.width - enemyWidth - 16;
    final enemyY = screenSize.height / 2 - enemyHeight + 16;
    final enemy = Enemy1(
      x: enemyX,
      y: enemyY,
      width: enemyWidth,
      height: enemyHeight,
    );
    components.add(enemy);
  }
}

/// 敵
class Enemy1 extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  Enemy1({
    @required this.x,
    @required this.y,
    @required this.width,
    @required this.height,
  }) : _bulletController = BulletController(
          playerRect: Rect.fromLTWH(x, y, width, height),
        ) {
    _rect = Rect.fromLTWH(x, y, width, height);
    _paint = Paint()..color = Colors.green;
    add(_bulletController);
  }

  final double x;
  final double y;
  final double width;
  final double height;

  final BulletController _bulletController;

  bool toRemove = false;

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
    return toRemove;
  }

  void removeBullet(PositionComponent player) {
    _bulletController.removeBullet(player);
  }
}
