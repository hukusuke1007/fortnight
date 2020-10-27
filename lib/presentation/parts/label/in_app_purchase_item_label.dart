import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/presentation/messages/index.dart';

class InAppPurchaseItemLabel extends PositionComponent
    with HasGameRef, Resizable, MessageControllerMixin {
  InAppPurchaseItemLabel({
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
            text: 'スーパーモード\n¥2,980',
            style: TextStyle(
              color: Colors.yellowAccent,
              fontSize: 60,
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
