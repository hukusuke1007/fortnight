import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flutter/material.dart';

/// バージョンラベル
class VersionLabel extends PositionComponent with HasGameRef, Resizable {
  VersionLabel({
    @required this.rect,
    this.version,
    this.textSpan,
  });

  final Rect rect;
  final String version;
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
            text: 'バージョン: ${version ?? ''}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
      ..layout();
    _textOffset =
        Offset(rect.right - tp.width - 32, rect.bottom - tp.height - 32);
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
