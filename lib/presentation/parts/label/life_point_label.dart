import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flutter/material.dart';

/// ライフポイント
class LifePointLabel extends PositionComponent with HasGameRef, Resizable {
  LifePointLabel({
    @required this.rect,
    this.textSpan,
  });

  final Rect rect;
  final TextSpan textSpan;
  final TextPainter tp = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  Offset textOffset;

  int value;
  bool toRemove = false;
  bool get isShowLabel => tp != null && textOffset != null;

  @override
  void update(double t) {
    super.update(t);
    if (value != null) {
      tp
        ..text = textSpan ??
            TextSpan(
              text: 'HP: ${value.toString()}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
        ..layout();
      textOffset = Offset(rect.center.dx - (tp.width / 2), rect.top - 32);
    }
  }

  @override
  void render(Canvas c) {
    if (isShowLabel) {
      tp.paint(c, textOffset);
    }
  }

  @override
  bool destroy() {
    return toRemove;
  }
}
