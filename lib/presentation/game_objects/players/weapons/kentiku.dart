import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/gen/index.dart';
import 'package:fortnight/presentation/messages/index.dart';

/// 建築のコントローラ
class KentikuController extends PositionComponent
    with
        HasGameRef,
        Tapable,
        ComposedComponent,
        Resizable,
        MessageControllerMixin {
  KentikuController({
    @required this.playerRect,
  }) {
    _fetch();
  }
  final Rect playerRect;

  Size screenSize;
  int get _count => components.whereType<Kentiku>().length;
  int get _maxCount => 1;

  @override
  void update(double t) {
    super.update(t);
  }

  @override
  void resize(Size size) {
    screenSize = size;
    print('resize $size');
  }

  void onCreate({double offsetX = 0}) {
    print('onCreate');
    if (_count < _maxCount) {
      final initialX = playerRect.right + 96 + offsetX;
      final initialY = playerRect.top - 32;
      const width = 24.0;
      final height = playerRect.height + 64;
      final data = Kentiku(
        x: initialX,
        y: initialY,
        width: width,
        height: height,
      );
      components.add(data);
      messageController.onKentiku.add(ComponentMessageState(
        data,
        objectStateType: ObjectStateType.create,
      ));

      Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.kentikuCreate));
    }
  }

  void onReset() {
    components.clear();
  }

  void _fetch() {
    messageController.fetchKentiku
        .where((event) => event.objectStateType == ObjectStateType.remove)
        .listen((event) {
      Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.kentikuBreak));
      components.clear();
    });
  }
}

/// 建築
class Kentiku extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  Kentiku({
    @required double x,
    @required double y,
    @required double width,
    @required double height,
  }) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    rect = Rect.fromLTWH(x, y, width, height);
    _paint = Paint()..color = Colors.orange;
  }

  Rect rect;
  Paint _paint;
  bool _toRemove = false;

  @override
  void update(double t) {
    super.update(t);
  }

  @override
  void render(Canvas c) {
    super.render(c);
    c.drawRect(rect, _paint);
  }

  @override
  bool destroy() {
    return _toRemove;
  }

  void onRemove() => _toRemove = true;
}
