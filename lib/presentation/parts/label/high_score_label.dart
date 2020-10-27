import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flutter/material.dart';

/// ハイスコアラベル
class HighScoreLabel extends PositionComponent with HasGameRef, Resizable {
  HighScoreLabel({
    @required this.rect,
    this.value,
    this.textSpan,
  });

  final Rect rect;
  final String value;
  final TextSpan textSpan;
  final TextPainter tp = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  Offset _textOffset;

  bool toRemove = false;
  bool get isShowLabel => tp != null && _textOffset != null;

  @override
  void update(double t) {
    super.update(t);
    tp
      ..text = textSpan ??
          TextSpan(
            text: 'ハイスコア: ${value ?? '-'}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
      ..layout();
    _textOffset =
        Offset(rect.right - tp.width - 32, rect.bottom - tp.height - 64);
  }

  @override
  void render(Canvas c) {
    if (isShowLabel) {
      tp.paint(c, _textOffset);
    }
  }

  @override
  bool destroy() {
    return toRemove;
  }
}
