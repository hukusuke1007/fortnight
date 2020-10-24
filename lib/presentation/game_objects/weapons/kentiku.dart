import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';
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
  int get _bulletCount => components.whereType<Kentiku>().length;
  int get _maxBulletCount => 1;

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
    if (_bulletCount < _maxBulletCount) {
      final initialX = playerRect.right + 32 + offsetX;
      final initialY = playerRect.top - 16;
      const width = 24.0;
      final height = playerRect.height + 64;
      final bullet = Kentiku(
        x: initialX,
        y: initialY,
        width: width,
        height: height,
      );
      components.add(bullet);
    }
  }

  void onRemoveKentiku(PositionComponent bullet) {
    components
        .where((element) =>
            (element as Kentiku).rect.left < bullet.toRect().right + 16)
        .map((e) => e as Kentiku)
        .forEach((element) {
      element.onRemove();
      print('removeBullet');
      print(components.length);
    });
  }

  void onReset() {
    components.clear();
  }

  void _fetch() {}
}

/// 建築
class Kentiku extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  Kentiku({
    @required this.x,
    @required this.y,
    @required this.width,
    @required this.height,
  }) {
    rect = Rect.fromLTWH(x, y, width, height);
    _paint = Paint()..color = Colors.orange;
  }

  final double x;
  final double y;
  final double width;
  final double height;

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
