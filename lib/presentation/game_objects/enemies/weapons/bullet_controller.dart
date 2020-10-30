import 'dart:math';
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
  int get _maxBigBulletCount => 2;

  int _frameCount = 0;
  int get _maxFrameCount => 60;
  bool _isEnableCreateBullet = true;
  int _bulletCreatedCount = 0;
  int _bigBulletCreatedCount = 0;

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
    final isBigBullet = _bulletCreatedCount >= 40;
    var maxFrameCountOffset = max(_maxFrameCount - _bulletCreatedCount, 30);
    if (isBigBullet) {
      maxFrameCountOffset = _bigBulletCreatedCount == 0
          ? _maxFrameCount * 5
          : _maxFrameCount + 10;
    }
    if (maxFrameCountOffset <= _frameCount) {
      _frameCount = 0;
      if (isBigBullet) {
        if (_bulletCount < _maxBigBulletCount) {
          _createBigBullet(150);
          _bigBulletCreatedCount += 1;
        }
      } else {
        _createBullet(offsetY, 150);
      }
      _bulletCreatedCount += 1;
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
            } else if (element is BigBullet &&
                messageController.fetchSuperMode.value) {
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
    const bulletWidth = 40.0;
    const bulletHeight = 40.0;
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

  void _createBigBullet(double speed) {
    print('_createBigBullet');
    const bulletWidth = 32.0 * 5;
    const bulletHeight = 32.0 * 5;
    final initialX = playerRect.left - (playerRect.width / 2) - 30;
    final initialY =
        playerRect.top + (playerRect.height / 2) - (bulletHeight / 2) - 10;
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
