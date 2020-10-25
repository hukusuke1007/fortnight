import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/presentation/game_objects/weapons/bullet.dart';
import 'package:fortnight/presentation/messages/index.dart';
import 'package:fortnight/presentation/parts/index.dart';

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

  @override
  void update(double t) {
    super.update(t);
  }

  @override
  void resize(Size size) {
    screenSize = size;
    if (enemy1 == null) {
      _createEnemy();
    }
    print('resize $size');
  }

  void onReset() {
    components.clear();
  }

  void onUpdateCollisionBullets(PositionComponent player) {
    components.whereType<Enemy1>().forEach((element) {
      element.onCollisionBullet(player);
    });
  }

  void _fetch() {
    messageController.fetchCollision
        .where((event) => event.to is Enemy1)
        .listen((event) {
      if (enemy1 != null && enemy1.hp > 0) {
        enemy1.hp = max(enemy1.hp - event.damagePoint, 0);
        print('enemy_hp ${enemy1.hp}');
        if (enemy1.hp == 0) {
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

/// 敵
class Enemy1 extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  Enemy1({
    @required this.x,
    @required this.y,
    @required this.width,
    @required this.height,
  })  : _bulletController = BulletController(
          playerRect: Rect.fromLTWH(x, y, width, height),
        ),
        _lifePointLabel = LifePointLabel(
          rect: Rect.fromLTWH(x, y, width, height),
        ) {
    _rect = Rect.fromLTWH(x, y, width, height);
    _paint = Paint()..color = Colors.green;
    hp = 1000;
    this..add(_bulletController)..add(_lifePointLabel);
  }

  final double x;
  final double y;
  final double width;
  final double height;

  int _hp = 1;
  int get hp => _hp;
  set hp(int value) {
    _hp = value;
    _lifePointLabel.value = _hp;
  }

  final BulletController _bulletController;
  final LifePointLabel _lifePointLabel;

  bool toRemove = false;

  Rect _rect;
  Paint _paint;

  @override
  void update(double t) {
    super.update(t);
  }

  @override
  void render(Canvas c) {
    super.render(c);
    c.drawRect(_rect, _paint);
  }

  @override
  bool destroy() {
    return _hp <= 0;
  }

  void onCollisionBullet(PositionComponent player) {
    _bulletController.onCollisionBullet(player);
  }
}
