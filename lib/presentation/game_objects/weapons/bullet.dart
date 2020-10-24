import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';

/// 銃弾のコントローラ
class BulletController extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  BulletController({
    @required this.playerRect,
  });
  final Rect playerRect;

  Size screenSize;
  int get _bulletCount => components.whereType<Bullet>().length;
  int get _maxBulletCount => 3;

  int _frameCount = 0;
  int get _maxFrameCount => 60;

  @override
  void update(double t) {
    super.update(t);

    // 生成
    createBullet(offsetY: 0);

    // // 削除
    // removeBullet();
  }

  @override
  void resize(Size size) {
    screenSize = size;
    print('resize $size');
  }

  void createBullet({double offsetY = 0}) {
    if (_maxFrameCount <= _frameCount) {
      _frameCount = 0;
      if (_bulletCount < _maxBulletCount) {
        _createBullet(offsetY);
      }
    } else {
      _frameCount += 1;
    }
  }

  void removeBullet(double position) {
    components
        .where((element) => (element as Bullet).rect.left < position)
        .map((e) => e as Bullet)
        .forEach((element) {
      element.remove();
      print('removeBullet');
      print(components.length);
    });
  }

  void reset() {
    components.clear();
  }

  void _createBullet(double offsetY) {
    print('createBullet');
    final initialX = playerRect.left - (playerRect.width / 2);
    final initialY = playerRect.top + (playerRect.height / 2) - 32 - offsetY;
    const bulletWidth = 32.0;
    const bulletHeight = 32.0;
    final bullet = Bullet(
      x: initialX,
      y: initialY,
      width: bulletWidth,
      height: bulletHeight,
      targetLocation: Offset(0, initialY),
    );
    components.add(bullet);
  }
}

/// 銃弾
class Bullet extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  Bullet({
    @required this.x,
    @required this.y,
    @required this.width,
    @required this.height,
    @required this.targetLocation,
  }) {
    rect = Rect.fromLTWH(x, y, width, height);
    paint = Paint()..color = Colors.white;
  }

  final double x;
  final double y;
  final double width;
  final double height;
  final Offset targetLocation;
  double speed = 150;
  Rect rect;
  Paint paint;
  bool get isDisappear => _toRemove;

  bool _toRemove = false;

  @override
  void update(double t) {
    super.update(t);

    final stepDistance = speed * t;
    final toTarget = targetLocation - Offset(rect.left, rect.top);
    // print(
    //     'location: $targetLocation, toTarget: $toTarget, ${toTarget.distance}');
    if (stepDistance < toTarget.distance) {
      final stepToTarget =
          Offset.fromDirection(toTarget.direction, stepDistance);
      rect = rect.shift(stepToTarget);
    }
  }

  @override
  void render(Canvas c) {
    super.render(c);
    c.drawRect(rect, paint);
  }

  @override
  bool destroy() {
    return _toRemove;
  }

  void remove() => _toRemove = true;
}
