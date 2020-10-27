import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/presentation/config.dart';
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

  PositionComponent _kentiku;

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

  void onCollisionBullet(PositionComponent player) {
    /// vs Kentiku
    if (_kentiku != null) {
      components
          .where((element) {
            final rect = (element as Bullet).rect;
            return _kentiku != null &&
                (rect.left < _kentiku.toRect().right + 8 &&
                    rect.left > _kentiku.toRect().left);
          })
          .map((e) => e as Bullet)
          .forEach((element) {
            messageController.onCollision.add(CollisionMessageState(
                from: element, to: _kentiku, damagePoint: 100));
            element.onRemove();
            print('removeKentiku');
          });
    }

    /// vs Player
    components
        .where((element) =>
            (element as Bullet).rect.left < player.toRect().right + 8)
        .map((e) => e as Bullet)
        .forEach((element) {
      messageController.onCollision.add(CollisionMessageState(
        from: element,
        to: player,
        damagePoint: EnemyConfig.attackBulletDamage,
      ));
      element.onRemove();
      print('removeBullet');
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

    messageController.fetchKentiku.listen((event) {
      if (event.objectStateType == ObjectStateType.create) {
        _kentiku = event.component;
      } else if (event.objectStateType == ObjectStateType.remove) {
        _kentiku = null;
      }
    });
  }
}

/// 銃弾
class Bullet extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  Bullet({
    @required double x,
    @required double y,
    @required double width,
    @required double height,
    @required this.targetLocation,
  }) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    rect = Rect.fromLTWH(x, y, width, height);
    _paint = Paint()..color = Colors.white;
    _painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )
      ..text = const TextSpan(
        text: '玉',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      )
      ..layout();
  }

  final Offset targetLocation;
  double speed = 150;
  Rect rect;
  Paint _paint;
  TextPainter _painter;
  bool get isDisappear => _toRemove;

  bool _toRemove = false;
  Offset _textOffset;

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
      _textOffset = Offset(rect.center.dx - _painter.width / 2,
          rect.top + height / 2 - _painter.height / 2);
    }
  }

  @override
  void render(Canvas c) {
    super.render(c);
    c.drawRect(rect, _paint);
    if (_textOffset != null) {
      _painter.paint(c, _textOffset);
    }
  }

  @override
  bool destroy() {
    return _toRemove;
  }

  void onRemove() => _toRemove = true;
}
