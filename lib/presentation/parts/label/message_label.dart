import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/presentation/messages/index.dart';

class MessageLabel extends PositionComponent
    with HasGameRef, Resizable, MessageControllerMixin {
  MessageLabel({
    @required this.screenSize,
    @required this.text,
    this.fontSize = 24.0,
    this.fontWeight = FontWeight.bold,
    this.color = Colors.white,
    this.textSpan,
  }) {
    _screenRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
  }

  final Size screenSize;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextSpan textSpan;
  final TextPainter tp = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  Offset textOffset;
  bool toRemove = false;
  bool get _isShowLabel => tp != null && textOffset != null;
  Rect _screenRect;

  @override
  void update(double t) {
    super.update(t);
    tp
      ..text = textSpan ??
          TextSpan(
            text: text,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          )
      ..layout();
    textOffset =
        Offset(_screenRect.center.dx - (tp.width / 2), _screenRect.top + 40);
  }

  @override
  void render(Canvas c) {
    if (_isShowLabel) {
      tp.paint(c, textOffset);
    }
  }

  @override
  bool destroy() {
    return toRemove;
  }
}
