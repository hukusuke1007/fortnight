import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';

class PaintComponent extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent {
  PaintComponent({
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
