import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';

class StartButton extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  StartButton({
    @required double x,
    @required double y,
    @required double width,
    @required double height,
  }) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    _rect = Rect.fromLTWH(x, y, width, height);
    _paint = Paint()..color = Colors.blueAccent;
    _painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )
      ..text = const TextSpan(
        text: 'スタート',
        style: TextStyle(
          color: Colors.white,
          fontSize: 36,
        ),
      )
      ..layout();
  }

  Rect _rect;
  Paint _paint;
  TextPainter _painter;

  @override
  void onTapDown(TapDownDetails details) {}

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
      Offset(x + width / 2 - _painter.width / 2,
          y + height / 2 - _painter.height / 2),
    );
  }

  bool isTapButton(TapDownDetails d) => toRect().contains(d.localPosition);
}
