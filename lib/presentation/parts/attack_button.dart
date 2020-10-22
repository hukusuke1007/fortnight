import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';

class AttackButton extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  AttackButton({
    @required this.x,
    @required this.y,
    @required this.width,
    @required this.height,
  }) {
    _rect = Rect.fromLTWH(x, y, width, height);
    _paint = Paint()..color = Colors.red;
    _painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )
      ..text = const TextSpan(
        text: '攻撃',
        style: TextStyle(
          color: Color(0xffffffff),
          fontSize: 36,
        ),
      )
      ..layout();
  }

  final double x;
  final double y;
  final double width;
  final double height;

  Rect _rect;
  Paint _paint;
  TextPainter _painter;

  @override
  void update(double t) {
    super.update(t);
  }

  @override
  void render(Canvas c) {
    super.render(c);
    c.drawRect(_rect, _paint);
    _painter.paint(
      c,
      Offset(x + (width / 4), y + (height / 8)),
    );
  }
}
