import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';

/// 敵のコントローラ
class Enemy1Controller extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
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

  void _createEnemy() {
    const enemyWidth = 120.0;
    const enemyHeight = 120.0;
    final enemy = Enemy1(
      x: screenSize.width - enemyWidth - 48,
      y: screenSize.height / 2 - enemyHeight,
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
    @required double x,
    @required double y,
    @required double width,
    @required double height,
  }) {
    _rect = Rect.fromLTWH(x, y, width, height);
    _paint = Paint()..color = Colors.green;
  }
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
}
