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
  Enemy1Controller() {
    final enemy = Enemy1(x: 100, y: 40, width: 200, height: 200);
    components.add(enemy);
  }

  @override
  void update(double t) {
    super.update(t);
  }

  void reset() {
    components.clear();
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
