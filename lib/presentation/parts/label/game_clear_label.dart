import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flutter/material.dart';

class GameClearLabel extends PositionComponent with HasGameRef, Resizable {
  GameClearLabel({
    @required this.screenSize,
    this.textSpan,
  }) {
    _screenRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
  }

  final Size screenSize;
  Rect _screenRect;
  final TextSpan textSpan;
  final TextPainter tp = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  Offset textOffset;

  bool toRemove = false;
  bool get isShowLabel => tp != null && textOffset != null;

  @override
  void update(double t) {
    super.update(t);
    tp
      ..text = textSpan ??
          const TextSpan(
            text: 'GAME CLEAR!!',
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 96,
              fontWeight: FontWeight.bold,
            ),
          )
      ..layout();
    textOffset = Offset(_screenRect.center.dx - (tp.width / 2),
        _screenRect.top + (tp.height / 2));
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
