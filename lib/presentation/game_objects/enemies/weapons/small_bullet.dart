import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fortnight/presentation/game_objects/enemies/weapons/bullet.dart';

/// 銃弾
class SmallBullet extends Bullet {
  SmallBullet({
    @required double x,
    @required double y,
    @required double width,
    @required double height,
    @required double speed,
    @required Offset targetLocation,
  }) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.speed = speed;
    this.targetLocation = targetLocation;
    rect = Rect.fromLTWH(x, y, width, height);
    _paint = Paint()..color = Colors.greenAccent;
    _painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )
      ..text = const TextSpan(
        text: '玉',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      )
      ..layout();
  }

  Paint _paint;
  TextPainter _painter;
  bool get isDisappear => _toRemove;

  bool _toRemove = false;
  Offset _textOffset;

  @override
  void update(double t) {
    super.update(t);

    final stepDistance = speed * t;
    final toTarget = targetLocation - Offset(rect.left, rect.top);
    // print(
    //     'location: $targetLocation, toTarget: $toTarget, ${toTarget.distance}');
    if (stepDistance < toTarget.distance) {
      final stepToTarget =
          Offset.fromDirection(toTarget.direction, stepDistance);
      rect = rect.shift(stepToTarget);
      _textOffset = Offset(rect.center.dx - _painter.width / 2,
          rect.top + height / 2 - _painter.height / 2);
    }
  }

  @override
  void render(Canvas c) {
    super.render(c);
    c.drawOval(rect, _paint);
    if (_textOffset != null) {
      _painter.paint(c, _textOffset);
    }
  }

  @override
  bool destroy() {
    return _toRemove;
  }

  @override
  void onRemove() => _toRemove = true;
}
