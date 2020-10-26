import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flutter/material.dart';

/// タイトル
class TitleLabel extends PositionComponent with HasGameRef, Resizable {
  TitleLabel({
    @required this.screenSize,
    this.textSpan,
  }) {
    width = screenSize.width * (3 / 4);
    height = 100;
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
            text: 'フォー！とNight',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          )
      ..layout();
    textOffset =
        Offset(_screenRect.center.dx - (tp.width / 2), _screenRect.top + 40);
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
