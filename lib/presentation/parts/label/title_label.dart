import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/gen/index.dart';
import 'package:fortnight/presentation/messages/index.dart';

class TitleLabel extends PositionComponent
    with HasGameRef, Resizable, MessageControllerMixin {
  TitleLabel({
    @required this.screenSize,
    this.textSpan,
  }) {
    _screenRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    _hgSprite = Sprite(Assets.images.hgWhite.filename);
    _fetch();
  }

  final Size screenSize;
  Rect _screenRect;
  final TextSpan textSpan;
  final TextPainter tp = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  Offset textOffset;
  Color _color = Colors.white;

  Sprite _hgSprite;
  Rect _hgRect;
  Color _hgColor = Colors.white;

  bool toRemove = false;
  bool get isShowLabel => tp != null && textOffset != null && _hgRect != null;

  @override
  void update(double t) {
    super.update(t);
    tp
      ..text = textSpan ??
          TextSpan(
            text: 'フォー！とNight',
            style: TextStyle(
              color: _color,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          )
      ..layout();
    textOffset =
        Offset(_screenRect.center.dx - (tp.width / 2), _screenRect.top + 64);

    const hgWidth = 64.0;
    const hgHeight = 108.0;
    _hgRect = Rect.fromLTWH(
        textOffset.dx - hgWidth, textOffset.dy - 16, hgWidth, hgHeight);
    _hgSprite.paint = Paint()
      ..colorFilter = ColorFilter.mode(_hgColor, BlendMode.srcIn);
  }

  @override
  void render(Canvas c) {
    if (isShowLabel) {
      tp.paint(c, textOffset);
      _hgSprite.renderRect(c, _hgRect);
    }
  }

  @override
  bool destroy() {
    return toRemove;
  }

  void _fetch() {
    messageController.fetchSuperMode.listen((event) {
      _color = event ? Colors.yellowAccent : Colors.white;
      _hgColor = _color;
    });
  }
}
