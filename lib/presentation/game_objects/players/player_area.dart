import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';

/// PlayerAreaコントローラ
class PlayerAreaController extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  PlayerAreaController() {}

  Size screenSize;

  CollisionArea get collisionArea =>
      components.firstWhere((value) => value is CollisionArea,
          orElse: () => null) as CollisionArea;

  @override
  void update(double t) {
    super.update(t);
  }

  @override
  void resize(Size size) {
    screenSize = size;
    if (collisionArea == null) {
      _createCollisionArea();
    }
    print('resize $size');
  }

  void reset() {
    components.clear();
  }

  void _createCollisionArea() {
    final component = CollisionArea(
      x: 0,
      y: screenSize.height - 150,
      width: screenSize.width,
      height: 20,
    );
    components.add(component);
  }
}

/// 当たり判定エリア
class CollisionArea extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  CollisionArea({
    @required double x,
    @required double y,
    @required double width,
    @required double height,
  }) {
    _rect = Rect.fromLTWH(x, y, width, height);
    _paint = Paint()..color = Colors.red;
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
}
