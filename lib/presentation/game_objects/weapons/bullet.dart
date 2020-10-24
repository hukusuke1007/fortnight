import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/presentation/messages/index.dart';

/// 銃弾のコントローラ
class BulletController extends PositionComponent
    with
        HasGameRef,
        Tapable,
        ComposedComponent,
        Resizable,
        MessageControllerMixin {
  BulletController({
    @required this.playerRect,
  }) {
    _fetch();
  }
  final Rect playerRect;

  Size screenSize;
  int get _bulletCount => components.whereType<Bullet>().length;
  int get _maxBulletCount => 3;

  int _frameCount = 0;
  int get _maxFrameCount => 60;
  bool _isEnableCreateBullet = true;

  @override
  void update(double t) {
    super.update(t);

    // TODO(shohei): 仮
    if (_isEnableCreateBullet) {
      onCreateBullet(offsetY: 0);
    }
  }

  @override
  void resize(Size size) {
    screenSize = size;
    print('resize $size');
  }

  void onCreateBullet({double offsetY = 0}) {
    if (_maxFrameCount <= _frameCount) {
      _frameCount = 0;
      if (_bulletCount < _maxBulletCount) {
        _createBullet(offsetY);
      }
    } else {
      _frameCount += 1;
    }
  }

  void onRemoveBullet(PositionComponent player) {
    components
        .where((element) =>
            (element as Bullet).rect.left < player.toRect().right + 16)
        .map((e) => e as Bullet)
        .forEach((element) {
      messageController.onCollision.add(CollisionMessageState(
        from: element,
        to: player,
        damagePoint: 10,
      ));
      element.onRemove();
      print('removeBullet');
      print(components.length);
    });
  }

  void onReset() {
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

  void _fetch() {
    messageController.fetchGameOver.listen((event) {
      _isEnableCreateBullet = !event;
      components.clear();
    });
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

  void onRemove() => _toRemove = true;
}
