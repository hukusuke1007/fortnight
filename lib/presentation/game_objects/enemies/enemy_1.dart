import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/presentation/config.dart';
import 'package:fortnight/presentation/parts/index.dart';

import 'weapons/index.dart';

/// 敵
class Enemy1 extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  Enemy1({
    @required double x,
    @required double y,
    @required double width,
    @required double height,
  })  : _bulletController = BulletController(
          playerRect: Rect.fromLTWH(x, y, width, height),
        ),
        _lifePointLabel = LifePointLabel(
          rect: Rect.fromLTWH(x, y, width, height),
        ) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    _rect = Rect.fromLTWH(x, y, width, height);
    _paint = Paint()..color = Colors.green;
    _painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )
      ..text = const TextSpan(
        text: '敵',
        style: TextStyle(
          color: Color(0xffffffff),
          fontSize: 64,
          fontWeight: FontWeight.bold,
        ),
      )
      ..layout();
    hp = EnemyConfig.hp;
    this..add(_bulletController)..add(_lifePointLabel);
  }

  int get hp => _hp;
  set hp(int value) {
    _hp = value;
    _lifePointLabel.value = _hp;
  }

  int _hp = 1;
  TextPainter _painter;

  final BulletController _bulletController;
  final LifePointLabel _lifePointLabel;

  Rect _rect;
  Paint _paint;

  @override
  void render(Canvas c) {
    super.render(c);
    c.drawRect(_rect, _paint);
    _painter.paint(
      c,
      Offset(x + width / 2 - _painter.width / 2,
          y + height / 2 - _painter.height / 2),
    );
  }

  @override
  bool destroy() {
    return _hp <= 0;
  }

  void onCollisionBullet(PositionComponent player) {
    _bulletController.onCollisionBullet(player);
  }
}
