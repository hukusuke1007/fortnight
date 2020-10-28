import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/presentation/config.dart';
import 'package:fortnight/presentation/game_objects/enemies/weapons/big_bullet.dart';
import 'package:fortnight/presentation/messages/index.dart';

import 'bullet.dart';
import 'small_bullet.dart';

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
  int _bulletCreatedCount = 0;

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
    // // TODO(shohei): frame制御
    if (_maxFrameCount <= _frameCount) {
      _frameCount = 0;
      if (_bulletCount < _maxBulletCount) {
        if (_bulletCreatedCount >= 20) {
          _createBigBullet(offsetY, 100);
        } else {
          var speed = 150.0;
          if (_bulletCreatedCount > 9) {
            speed = 300.0;
          }
          _createBullet(offsetY, speed);
        }
        _bulletCreatedCount += 1;
      }
    } else {
      _frameCount += 1;
    }
    print('bulletCreatedCount $_bulletCreatedCount');
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
            if (element is SmallBullet) {
              element.onRemove();
            }
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

  void _createBullet(double offsetY, double speed) {
    print('createBullet');
    const bulletWidth = 32.0;
    const bulletHeight = 32.0;
    final initialX = playerRect.left - (playerRect.width / 2);
    final initialY =
        playerRect.top + (playerRect.height / 2) - bulletHeight - offsetY;
    final bullet = SmallBullet(
      x: initialX,
      y: initialY,
      width: bulletWidth,
      height: bulletHeight,
      speed: speed,
      targetLocation: Offset(0, initialY),
    );
    components.add(bullet);
  }

  void _createBigBullet(double offsetY, double speed) {
    print('_createBigBullet');
    const bulletWidth = 32.0 * 3;
    const bulletHeight = 32.0 * 3;
    final initialX = playerRect.left - (playerRect.width / 2);
    final initialY =
        playerRect.top + (playerRect.height / 2) - bulletHeight - offsetY;
    final bullet = BigBullet(
      x: initialX,
      y: initialY,
      width: bulletWidth,
      height: bulletHeight,
      speed: speed,
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
