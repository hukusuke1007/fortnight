import 'dart:async';
import 'dart:math';
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

import 'enemy_1.dart';

/// 敵のコントローラ
class Enemy1Controller extends PositionComponent
    with
        HasGameRef,
        Tapable,
        ComposedComponent,
        Resizable,
        MessageControllerMixin {
  Enemy1Controller() {
    _fetch();
  }

  Size screenSize;
  Enemy1 get enemy1 =>
      components.firstWhere((value) => value is Enemy1, orElse: () => null)
          as Enemy1;

  StreamSubscription<CollisionMessageState> _collisionDisposer;

  @override
  void resize(Size size) {
    screenSize = size;
    if (enemy1 == null) {
      _createEnemy();
    }
    print('resize $size');
  }

  Future<void> dispose() async {
    await _collisionDisposer?.cancel();
  }

  void onUpdateCollisionBullets(PositionComponent player) {
    components.whereType<Enemy1>().forEach((element) {
      element.onCollisionBullet(player);
    });
  }

  void _fetch() {
    _collisionDisposer ??= messageController.fetchCollision
        .where((event) => event.to is Enemy1)
        .listen((event) {
      if (enemy1 != null && enemy1.hp > 0) {
        enemy1.hp = max(enemy1.hp - event.damagePoint, 0);
        print('enemy_hp ${enemy1.hp}');
        if (enemy1.hp == 0) {
          Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.bomb2));
          messageController.onGameClear.add(true);
        }
      }
    });
  }

  void _createEnemy() {
    const enemyWidth = 120.0;
    const enemyHeight = 120.0;
    final enemyX = screenSize.width - enemyWidth - 16;
    final enemyY = screenSize.height / 2 - enemyHeight + 16;
    final enemy = Enemy1(
      x: enemyX,
      y: enemyY,
      width: enemyWidth,
      height: enemyHeight,
    );
    components.add(enemy);
  }
}
